# frozen_string_literal: true

require 'faraday'
require 'json'

API_VERIFY_URL = 'https://api.hunter.io/v2/email-verifier?'

module EmailHunter
  class Verify
    attr_reader :result, :score, :regexp, :gibberish, :disposable, :webmail, :mx_records, :smtp_server, :smtp_check,
                :accept_all, :sources, :meta, :key, :email

    def initialize(email, key)
      @email = email
      @key = key
    end

    def hunt
      Struct.new(*data.keys).new(*data.values)
    end

    def data
      @data ||= begin
        response = Faraday.new("#{API_VERIFY_URL}email=#{email}&api_key=#{key}").get

        return [] unless response.success?

        JSON.parse(response.body, { symbolize_names: true })
      end
    end
  end
end
