# frozen_string_literal: true

require 'faraday'
require 'json'

module EmailHunter
  class Exist
    API_URL = 'https://api.emailhunter.co/v1/exist'

    attr_reader :email, :key

    def initialize(email, key)
      @email = email
      @key = key
    end

    def hunt
      response_data = fetch_exist_data
      return nil if response_data.empty?

      Struct.new(*response_data.keys).new(*response_data.values)
    end

    private

    def fetch_exist_data
      @fetch_exist_data ||= begin
        connection = Faraday.new
        response = connection.get(API_URL, email: email, api_key: key)

        return {} unless response.success?

        JSON.parse(response.body, symbolize_names: true)
      end
    end
  end
end
