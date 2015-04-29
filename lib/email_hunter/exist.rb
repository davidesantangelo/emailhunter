require 'faraday'
require 'json'

API_EXISTS_URL = 'https://api.emailhunter.co/v1/exist?'

module EmailHunter
  class Exist
    attr_reader :status, :email, :exist, :sources

  	def initialize(email, key)
      @email = email
      @key = key
    end

    def hunt
      response = apiresponse
      OpenStruct.new(response) unless response.empty?
    end

    private

    def apiresponse
      url = "#{API_EXISTS_URL}email=#{@email}&api_key=#{@key}"
      response = Faraday.get(URI.parse(URI.encode(url)))
      response.success? ? JSON.parse(response.body) : []
    end
  end
end