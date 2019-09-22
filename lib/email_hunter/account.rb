require 'faraday'
require 'json'

API_ACCOUNT_URL = 'https://api.hunter.io/v2/account?'

module EmailHunter
  class Account
    attr_reader :result, :first_name, :last_name, :email, :plan_name, :plan_level, :reset_date, :team_id, :calls

    def initialize(key)
      @key = key
    end

    def hunt
      response = apiresponse
      Struct.new(*response.keys).new(*response.values) unless response.empty?
    end

    private

    def apiresponse
      url = URI.parse(URI.encode("#{API_ACCOUNT_URL}&api_key=#{@key}"))
      response = Faraday.new(url).get
      response.success? ? JSON.parse(response.body, {symbolize_names: true}) : []
    end
  end
end
