require 'faraday'
require 'json'

API_COUNT_URL = 'https://api.hunter.io/v2/email-count?'.freeze

module EmailHunter
  class Count
    attr_reader :data, :meta, :domain

    def initialize(domain)
      @domain = domain
    end

    def hunt
      Struct.new(*data.keys).new(*data.values)
    end

    def apiresponse
      @data ||= begin
        response = Faraday.new("#{API_COUNT_URL}domain=#{domain}").get

        return [] unless response.success?

        JSON.parse(response.body, { symbolize_names: true })
      end
    end
  end
end
