# frozen_string_literal: true

require 'faraday'
require 'json'

module EmailHunter
  class Verify
    API_URL = 'https://api.hunter.io/v2/email-verifier'
    
    attr_reader :email, :key

    def initialize(email, key)
      @email = email
      @key = key
    end

    def hunt
      response_data = fetch_verify_data
      return nil if response_data.empty?
      
      Struct.new(*response_data.keys).new(*response_data.values)
    end

    private

    def fetch_verify_data
      @fetch_verify_data ||= begin
        connection = Faraday.new
        response = connection.get(API_URL, email: email, api_key: key)
        
        return {} unless response.success?

        JSON.parse(response.body, symbolize_names: true)
      end
    end
  end
end
