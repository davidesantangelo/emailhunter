require 'faraday'
require 'json'

API_SEARCH_URL = 'https://api.hunter.io/v2/domain-search?'

module EmailHunter
  class Search
    attr_reader :meta, :webmail, :emails, :pattern, :domain

    def initialize(domain, key, params = {})
      @domain = domain
      @key = key
      @params = params
    end

    def hunt
      response = apiresponse
      Struct.new(*response.keys).new(*response.values) unless response.empty?
    end

    private

    def apiresponse
      url =
        URI.parse(URI.encode(
          "#{API_SEARCH_URL}domain=#{@domain}&api_key=#{@key}&type=#{@params[:type]}&offset=#{@params[:offset]}&limit=#{@params[:limit]}")
        )
      response = Faraday.new(url).get
      response.success? ? JSON.parse(response.body, {symbolize_names: true}) : []
    end
  end
end
