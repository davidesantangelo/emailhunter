# frozen_string_literal: true

require 'faraday'
require 'json'

API_FINDER_URL = 'https://api.hunter.io/v2/email-finder?'

module EmailHunter
  class Finder
    attr_reader :email, :score, :sources, :domain, :meta

    def initialize(domain, first_name, last_name, key)
      @domain = domain
      @first_name = first_name
      @last_name = last_name
      @key = key
    end

    def hunt
      response = apiresponse
      Struct.new(*response.keys).new(*response.values) unless response.empty?
    end

    private

    def apiresponse
      url = URI.parse(URI.encode("#{API_FINDER_URL}domain=#{@domain}&first_name=#{@first_name}&last_name=#{@last_name}&api_key=#{@key}"))
      response = Faraday.new(url).get
      response.success? ? JSON.parse(response.body, { symbolize_names: true }) : []
    end
  end
end
