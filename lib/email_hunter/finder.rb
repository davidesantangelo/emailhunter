# frozen_string_literal: true

require 'faraday'
require 'json'

API_FINDER_URL = 'https://api.hunter.io/v2/email-finder?'

module EmailHunter
  class Finder
    attr_reader :email, :score, :sources, :domain, :meta, :key, :first_name, :last_name

    def initialize(domain, first_name, last_name, key)
      @domain = domain
      @first_name = first_name
      @last_name = last_name
      @key = key
    end

    def hunt
      Struct.new(*data.keys).new(*data.values)
    end

    def data
      @data ||= begin
        response = Faraday.new("#{API_FINDER_URL}domain=#{domain}&first_name=#{first_name}&last_name=#{last_name}&api_key=#{key}").get

        return [] unless response.success?

        JSON.parse(response.body, { symbolize_names: true })
      end
    end
  end
end
