# frozen_string_literal: true

require 'faraday'
require 'json'

module EmailHunter
  class Count
    API_URL = 'https://api.hunter.io/v2/email-count'
    
    attr_reader :domain

    def initialize(domain)
      @domain = domain
    end

    def hunt
      response_data = fetch_count_data
      return nil if response_data.empty?
      
      Struct.new(*response_data.keys).new(*response_data.values)
    end

    private

    def fetch_count_data
      @fetch_count_data ||= begin
        connection = Faraday.new
        response = connection.get(API_URL, domain: domain)
        
        return {} unless response.success?

        JSON.parse(response.body, symbolize_names: true)
      end
    end
  end
end
