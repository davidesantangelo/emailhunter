# frozen_string_literal: true

require 'faraday'
require 'json'

module EmailHunter
  class Discover
    API_URL = 'https://api.hunter.io/v2/discover'

    attr_reader :query, :key, :params

    def initialize(query, key, params = {})
      @query = query
      @key = key
      @params = params
    end

    def hunt
      response_data = fetch_discover_data
      return nil if response_data.empty?

      # Convert to OpenStruct for easy access
      result = OpenStruct.new(response_data)

      # Recursively convert nested hashes to OpenStructs
      convert_hash_to_struct(result, response_data)

      result
    end

    private

    def convert_hash_to_struct(struct, hash)
      hash.each do |key, value|
        if value.is_a?(Hash)
          struct[key] = OpenStruct.new(value)
          convert_hash_to_struct(struct[key], value)
        elsif value.is_a?(Array) && value.first.is_a?(Hash)
          struct[key] = value.map { |item| OpenStruct.new(item) }
        end
      end
    end

    def limit
      params.fetch(:limit, 100).to_i
    end

    def offset
      params.fetch(:offset, 0).to_i
    end

    def filters
      params.fetch(:filters, {})
    end

    def fetch_discover_data
      @fetch_discover_data ||= begin
        connection = Faraday.new
        request_data = {
          query: query,
          api_key: key,
          limit: limit,
          offset: offset
        }

        # Add filters if provided
        request_data[:filters] = filters unless filters.empty?

        response = connection.post(API_URL) do |req|
          req.headers['Content-Type'] = 'application/json'
          req.body = request_data.to_json
        end

        return {} unless response.success?

        JSON.parse(response.body, symbolize_names: true)
      end
    end
  end
end
