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
      Struct.new(*response.keys).new(*response.values) unless response.empty?
    end

    private

    def apiresponse
      url = "#{API_EXISTS_URL}email=#{@email}&api_key=#{@key}"
      response = (Faraday.new URI.parse(URI.encode(url)), :ssl => {:verify => false}).get
      response.success? ? JSON.parse(response.body, {symbolize_names: true}) : []
    end
  end
end