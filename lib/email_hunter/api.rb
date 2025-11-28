# frozen_string_literal: true

require 'uri'

%w[exist search finder verify count account company people discover leads campaigns lead_enrichment company_enrichment
   combined_enrichment].each do |file|
  require_relative file
end

module EmailHunter
  # Main API client for EmailHunter services
  class Api
    attr_reader :key

    def initialize(key)
      @key = key
    end

    # Domain search API
    def search(domain, params = {})
      execute_hunt(Search, domain, params)
    end

    # Email exist API
    def exist(email)
      execute_hunt(Exist, email)
    end

    # Email verify API
    def verify(email)
      execute_hunt(Verify, email)
    end

    # Email Finder API
    def finder(domain, first_name, last_name)
      EmailHunter::Finder.new(domain, first_name, last_name, key).hunt
    end

    # Email Count API
    def count(domain)
      execute_hunt(Count, domain)
    end

    # Account Information API
    def account
      execute_hunt(Account)
    end

    # Company Information API
    def company(domain)
      execute_hunt(Company, domain)
    end

    # People Information API
    def people(domain)
      execute_hunt(People, domain)
    end

    # Discover API - Search companies using natural language
    def discover(query, params = {})
      execute_hunt(Discover, query, params)
    end

    # Leads API - List leads
    def leads(params = {})
      Leads.new(key, action: :list, params: params).hunt
    end

    # Leads API - Create lead
    def lead_create(data)
      Leads.new(key, action: :create, data: data).hunt
    end

    # Leads API - Update lead
    def lead_update(id, data)
      Leads.new(key, action: :update, lead_id: id, data: data).hunt
    end

    # Leads API - Delete lead
    def lead_delete(id)
      Leads.new(key, action: :delete, lead_id: id).hunt
    end

    # Campaigns API - List campaigns
    def campaigns(params = {})
      Campaigns.new(key, action: :list, params: params).hunt
    end

    # Campaigns API - Get campaign recipients
    def campaign_recipients(campaign_id, params = {})
      Campaigns.new(key, action: :recipients, campaign_id: campaign_id, params: params).hunt
    end

    # Campaigns API - Add recipient to campaign
    def campaign_add_recipient(campaign_id, data)
      Campaigns.new(key, action: :add_recipient, campaign_id: campaign_id, data: data).hunt
    end

    # Campaigns API - Delete recipient from campaign
    def campaign_delete_recipient(campaign_id, email)
      Campaigns.new(key, action: :delete_recipient, campaign_id: campaign_id, data: { email: email }).hunt
    end

    # Lead Enrichment API - Enrich person data
    def lead_enrichment(email: nil, linkedin: nil)
      LeadEnrichment.new(key, email: email, linkedin: linkedin).hunt
    end

    # Company Enrichment API - Enrich company data
    def company_enrichment(domain)
      CompanyEnrichment.new(domain, key).hunt
    end

    # Combined Enrichment API - Enrich both lead and company data
    def combined_enrichment(email: nil, linkedin: nil)
      CombinedEnrichment.new(key, email: email, linkedin: linkedin).hunt
    end

    private

    # Helper method to reduce repetition
    def execute_hunt(klass, *args)
      case klass.name.split('::').last
      when 'Search', 'Discover'
        # Search and Discover expect (value, key, params)
        value, params = args
        klass.new(value, key, params || {}).hunt
      when 'Count'
        # Count doesn't need key
        domain = args.first
        klass.new(domain).hunt
      when 'Account'
        # Account only needs key
        klass.new(key).hunt
      else
        # Other classes expect (value, key)
        value = args.first
        klass.new(value, key).hunt
      end
    end
  end
end
