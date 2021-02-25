require 'faraday'
require 'json'

API_COUNT_URL = 'https://api.hunter.io/v2/email-count?'.freeze

module EmailHunter
  class Count
    attr_reader :data, :meta

    def initialize(domain)
      @domain = domain
    end

    def hunt
      response = apiresponse
      Struct.new(*response.keys).new(*response.values) unless response.empty?
    end

    private

    def apiresponse
      response = Faraday.new("#{API_COUNT_URL}domain=#{@domain}").get
      response.success? ? JSON.parse(response.body, { symbolize_names: true }) : []
    end
  end
end
