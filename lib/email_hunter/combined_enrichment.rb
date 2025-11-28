# frozen_string_literal: true

require 'ostruct'
require_relative 'lead_enrichment'
require_relative 'company_enrichment'

module EmailHunter
  class CombinedEnrichment
    attr_reader :key, :email, :linkedin

    def initialize(key, email: nil, linkedin: nil)
      @key = key
      @email = email
      @linkedin = linkedin

      raise ArgumentError, 'Either email or linkedin must be provided' if email.nil? && linkedin.nil?
    end

    def hunt
      # First get lead enrichment data
      lead_data = LeadEnrichment.new(key, email: email, linkedin: linkedin).hunt
      return nil if lead_data.nil?

      # Extract domain from employment if available
      domain = lead_data.data.employment&.domain
      return lead_data if domain.nil?

      # Get company enrichment data
      company_data = CompanyEnrichment.new(domain, key).hunt

      # Combine the data
      OpenStruct.new(
        lead: lead_data,
        company: company_data,
        meta: OpenStruct.new(
          email: email,
          linkedin: linkedin,
          domain: domain
        )
      )
    rescue StandardError => e
      # If company enrichment fails, just return lead data
      OpenStruct.new(
        lead: lead_data,
        company: nil,
        meta: OpenStruct.new(
          email: email,
          linkedin: linkedin,
          error: e.message
        )
      )
    end
  end
end
