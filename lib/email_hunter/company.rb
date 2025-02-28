# frozen_string_literal: true

require 'faraday'
require 'json'
require 'ostruct'

module EmailHunter
  class Company
    API_URL = 'https://api.hunter.io/v2/companies/find'
    
    attr_reader :domain, :key

    def initialize(domain, key)
      @domain = domain
      @key = key
    end

    def hunt
      response_data = fetch_company_data
      return nil if response_data.empty?
      
      # Convert nested data structure to a Struct
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

    def fetch_company_data
      @fetch_company_data ||= begin
        connection = Faraday.new
        response = connection.get(API_URL, domain: domain, api_key: key)
        
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