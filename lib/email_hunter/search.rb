require 'faraday'
require 'json'

API_SEARCH_URL = 'https://api.emailhunter.co/v1/search?'

module EmailHunter
  class Search
    attr_reader :status, :results, :webmail, :emails, :offset

    def initialize(domain, key)
      @domain = domain
      @key = key
    end

    def hunt
      response = apiresponse
      Struct.new(*response.keys).new(*response.values) unless response.empty?
    end

    private

    def apiresponse
      url = "#{API_SEARCH_URL}domain=#{@domain}&api_key=#{@key}"
      response = (Faraday.new URI.parse(URI.encode(url)), :ssl => {:verify => false}).get
      response.success? ? JSON.parse(response.body, {symbolize_names: true}) : []
    end
  end
end