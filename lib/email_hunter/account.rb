# frozen_string_literal: true

require 'faraday'
require 'json'

module EmailHunter
  class Account
    API_URL = 'https://api.hunter.io/v2/account'
    
    attr_reader :result, :first_name, :last_name, :email, :plan_name, :plan_level, :reset_date, :team_id, :calls,
                :requests

    def initialize(key)
      @key = key
    end

    def hunt
      response = fetch_account_data
      parse_response(response)
    end

    private

    def fetch_account_data
      connection = Faraday.new
      connection.get(API_URL, api_key: @key)
    end

    def parse_response(response)
      return nil unless response.success?
      
      data = JSON.parse(response.body, symbolize_names: true)
      return nil if data.empty?
      
      Struct.new(*data.keys).new(*data.values)
    end
  end
end
