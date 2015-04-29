require 'faraday'
require 'json'
require 'ostruct'

API_SEARCH_URL = 'https://api.emailhunter.co/v1/search?'

module EmailHunter
  class Search
    attr_reader :status, :results, :emails

  	def initialize(domain, key)
  		@domain = domain
      @key = key
  	end

    def hunt
      response = apiresponse
      OpenStruct.new(response) unless response.empty?
    end

    private

    def apiresponse
      url = "#{API_SEARCH_URL}domain=#{@domain}&api_key=#{@key}"
      response = Faraday.get(URI.parse(URI.encode(url)))
      response.success? ? JSON.parse(response.body) : []
    end
  end
end