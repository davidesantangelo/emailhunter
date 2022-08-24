# frozen_string_literal: true

require 'faraday'
require 'json'

API_EXIST_URL = 'https://api.emailhunter.co/v1/exist?'

module EmailHunter
  class Exist
    attr_reader :status, :email, :exist, :sources, :key

    def initialize(email, key)
      @email = email
      @key = key
    end

    def hunt
      Struct.new(*data.keys).new(*data.values)
    end

    def data
      @data ||= begin
        response = Faraday.new("#{API_EXIST_URL}email=#{email}&api_key=#{key}").get

        return {} unless response.success?

        JSON.parse(response.body, { symbolize_names: true })
      end
    end
  end
end
