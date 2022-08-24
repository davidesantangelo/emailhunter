# frozen_string_literal: true

require 'faraday'
require 'json'

API_SEARCH_URL = 'https://api.hunter.io/v2/domain-search?'

module EmailHunter
  class Search
    attr_reader :meta, :webmail, :emails, :pattern, :domain, :params, :key

    def initialize(domain, key, params = {})
      @domain = domain
      @key = key
      @params = params
    end

    def hunt
      Struct.new(*data.keys).new(*data.values)
    end

    def limit
      params[:limit] || 10
    end

    def offset
      params[:offset] || 0
    end

    def data
      @data ||= begin
        response = Faraday.new("#{API_SEARCH_URL}domain=#{domain}&api_key=#{key}&type=#{params[:type]}&offset=#{offset}&limit=#{limit}").get

        return {} unless response.success?

        JSON.parse(response.body, { symbolize_names: true })
      end
    end
  end
end
