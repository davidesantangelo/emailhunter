# frozen_string_literal: true

require 'faraday'
require 'json'
require 'ostruct'

module EmailHunter
  class Leads
    API_URL = 'https://api.hunter.io/v2/leads'

    attr_reader :key, :params, :action, :lead_id, :data

    def initialize(key, action: :list, lead_id: nil, data: nil, params: {})
      @key = key
      @action = action
      @lead_id = lead_id
      @data = data
      @params = params
    end

    def hunt
      case action
      when :list
        list_leads
      when :create
        create_lead
      when :update
        update_lead
      when :delete
        delete_lead
      else
        raise ArgumentError, "Unknown action: #{action}"
      end
    end

    private

    def list_leads
      response_data = fetch_leads_data
      return nil if response_data.empty?

      # Convert nested data structure to OpenStruct
      result = OpenStruct.new(
        data: OpenStruct.new(response_data[:data] || {}),
        meta: OpenStruct.new(response_data[:meta] || {})
      )

      # Convert leads array to OpenStruct objects
      result.data.leads = result.data.leads.map { |lead| OpenStruct.new(lead) } if result.data.leads.is_a?(Array)

      result
    end

    def create_lead
      response_data = post_lead_data
      return nil if response_data.empty?

      OpenStruct.new(response_data)
    end

    def update_lead
      response_data = put_lead_data
      return nil if response_data.empty?

      OpenStruct.new(response_data)
    end

    def delete_lead
      response = delete_lead_data
      response.success?
    end

    def fetch_leads_data
      @fetch_leads_data ||= begin
        connection = Faraday.new
        request_params = {
          api_key: key,
          limit: params.fetch(:limit, 20),
          offset: params.fetch(:offset, 0)
        }

        # Add optional filters
        request_params[:leads_list_id] = params[:leads_list_id] if params[:leads_list_id]

        response = connection.get(API_URL, request_params)

        return {} unless response.success?

        JSON.parse(response.body, symbolize_names: true)
      end
    end

    def post_lead_data
      connection = Faraday.new
      request_data = data.merge(api_key: key)

      response = connection.post(API_URL) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = request_data.to_json
      end

      return {} unless response.success?

      JSON.parse(response.body, symbolize_names: true)
    end

    def put_lead_data
      connection = Faraday.new
      url = "#{API_URL}/#{lead_id}"
      request_data = data.merge(api_key: key)

      response = connection.put(url) do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = request_data.to_json
      end

      return {} unless response.success?

      JSON.parse(response.body, symbolize_names: true)
    end

    def delete_lead_data
      connection = Faraday.new
      url = "#{API_URL}/#{lead_id}"

      connection.delete(url, api_key: key)
    end
  end
end
