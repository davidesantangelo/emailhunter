# frozen_string_literal: true

require 'faraday'
require 'json'
require 'ostruct'

module EmailHunter
  class Campaigns
    API_URL = 'https://api.hunter.io/v2/campaigns'

    attr_reader :key, :params, :action, :campaign_id, :data

    def initialize(key, action: :list, campaign_id: nil, data: nil, params: {})
      @key = key
      @action = action
      @campaign_id = campaign_id
      @data = data
      @params = params
    end

    def hunt
      case action
      when :list
        list_campaigns
      when :recipients
        list_recipients
      when :add_recipient
        add_recipient
      when :delete_recipient
        delete_recipient
      else
        raise ArgumentError, "Unknown action: #{action}"
      end
    end

    private

    def list_campaigns
      response_data = fetch_campaigns_data
      return nil if response_data.empty?

      # Convert to OpenStruct for easy access
      result = OpenStruct.new(response_data)

      # Convert campaigns array to OpenStruct objects if it exists
      if result.data.is_a?(Hash) && result.data[:campaigns].is_a?(Array)
        campaigns_array = result.data[:campaigns].map { |c| OpenStruct.new(c) }
        result.data = OpenStruct.new(result.data.merge(campaigns: campaigns_array))
      elsif result.data.is_a?(OpenStruct) && result.data.campaigns.is_a?(Array)
        result.data.campaigns = result.data.campaigns.map { |c| OpenStruct.new(c) }
      end

      result
    end

    def list_recipients
      response_data = fetch_recipients_data
      return nil if response_data.empty?

      result = OpenStruct.new(response_data)

      # Convert recipients array to OpenStruct objects if it exists
      if result.data.is_a?(Hash) && result.data[:recipients].is_a?(Array)
        recipients_array = result.data[:recipients].map { |r| OpenStruct.new(r) }
        result.data = OpenStruct.new(result.data.merge(recipients: recipients_array))
      elsif result.data.is_a?(OpenStruct) && result.data.recipients.is_a?(Array)
        result.data.recipients = result.data.recipients.map { |r| OpenStruct.new(r) }
      end

      result
    end

    def add_recipient
      response_data = post_recipient_data
      return nil if response_data.empty?

      OpenStruct.new(response_data)
    end

    def delete_recipient
      response = delete_recipient_data
      response.success?
    end

    def fetch_campaigns_data
      connection = Faraday.new
      request_params = {
        api_key: key,
        limit: params.fetch(:limit, 20),
        offset: params.fetch(:offset, 0)
      }

      response = connection.get(API_URL, request_params)

      return {} unless response.success?

      JSON.parse(response.body, symbolize_names: true)
    end

    def fetch_recipients_data
      connection = Faraday.new
      url = "#{API_URL}/#{campaign_id}/recipients"
      request_params = {
        api_key: key,
        limit: params.fetch(:limit, 20),
        offset: params.fetch(:offset, 0)
      }

      response = connection.get(url, request_params)

      return {} unless response.success?

      JSON.parse(response.body, symbolize_names: true)
    end

    def post_recipient_data
      connection = Faraday.new
      url = "#{API_URL}/#{campaign_id}/recipients"
      request_data = data.merge(api_key: key)

      response = connection.post(url) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = request_data.to_json
      end

      return {} unless response.success?

      JSON.parse(response.body, symbolize_names: true)
    end

    def delete_recipient_data
      connection = Faraday.new
      email = data[:email]
      url = "#{API_URL}/#{campaign_id}/recipients/#{email}"

      connection.delete(url, api_key: key)
    end
  end
end
