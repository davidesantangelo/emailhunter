# frozen_string_literal: true

require 'faraday'
require 'json'
require 'ostruct'

module EmailHunter
  class LeadEnrichment
    API_URL = 'https://api.hunter.io/v2/people/find'

    attr_reader :key, :email, :linkedin

    def initialize(key, email: nil, linkedin: nil)
      @key = key
      @email = email
      @linkedin = linkedin

      raise ArgumentError, 'Either email or linkedin must be provided' if email.nil? && linkedin.nil?
    end

    def hunt
      response_data = fetch_enrichment_data
      return nil if response_data.empty?

      # Convert nested data structure to OpenStruct
      data = response_data[:data]
      meta = response_data[:meta]

      result = OpenStruct.new(
        data: OpenStruct.new(data),
        meta: OpenStruct.new(meta)
      )

      # Recursively convert nested hashes to OpenStructs for deeper access
      convert_hash_to_struct(result.data, data)

      result
    end

    private

    def fetch_enrichment_data
      @fetch_enrichment_data ||= begin
        connection = Faraday.new
        request_params = { api_key: key }

        request_params[:email] = email if email
        request_params[:linkedin_handle] = linkedin if linkedin

        response = connection.get(API_URL, request_params)

        return {} unless response.success?

        JSON.parse(response.body, symbolize_names: true)
      end
    end

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
  end
end
