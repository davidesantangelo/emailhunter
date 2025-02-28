# frozen_string_literal: true

require 'faraday'
require 'json'

module EmailHunter
  class Search
    API_URL = 'https://api.hunter.io/v2/domain-search'
    
    attr_reader :domain, :key, :params

    def initialize(domain, key, params = {})
      @domain = domain
      @key = key
      @params = params
    end

    def hunt
      response_data = fetch_search_data
      return nil if response_data.empty?
      
      Struct.new(*response_data.keys).new(*response_data.values)
    end

    private

    def limit
      params.fetch(:limit, 10).to_i
    end

    def offset
      params.fetch(:offset, 0).to_i
    end

    def fetch_search_data
      @fetch_search_data ||= begin
        connection = Faraday.new
        request_params = {
          domain: domain,
          api_key: key,
          offset: offset,
          limit: limit
        }
        
        request_params[:type] = params[:type] if params[:type]
        response = connection.get(API_URL, request_params)
        
        return {} unless response.success?

        JSON.parse(response.body, symbolize_names: true)
      end
    end
  end
end
