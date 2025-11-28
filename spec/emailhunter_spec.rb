# frozen_string_literal: true

require 'spec_helper'
require 'vcr'

describe EmailHunter do
  let(:key) { '78fe0358ef51006a14b04aff1ea3e3665dac8118' }

  it 'has a version number' do
    expect(EmailHunter::VERSION).not_to be nil
  end

  it 'has an api_key' do
    expect(key).not_to eq('your api key')
    expect(key).not_to be_empty
  end

  it 'search API expect webmail \'google.com\'' do
    VCR.use_cassette 'search API expect domain \'google.com\'' do
      email_hunter = EmailHunter.new(key)
      expect(email_hunter.search('google.com').data.fetch(:domain)).to eq('google.com')
    end
  end

  it 'search API expect meta:results > 0' do
    VCR.use_cassette 'search API expect meta:results > 0' do
      email_hunter = EmailHunter.new(key)
      expect(email_hunter.search('google.com').meta.fetch(:results)).to be > 0
    end
  end

  it 'search API expect webmail false' do
    VCR.use_cassette 'search API expect webmail false' do
      email_hunter = EmailHunter.new(key)
      expect(email_hunter.search('stripe.com').data.fetch(:webmail)).to be == false
    end
  end

  it 'verify API expect score > 0 with email steli@close.io' do
    VCR.use_cassette 'verify API expect score > 0 with email steli@close.io' do
      email_hunter = EmailHunter.new(key)
      expect(email_hunter.verify('steli@close.io').data.fetch(:score)).to be > 0
    end
  end

  it 'search API expect first email type == generic OR personal with stripe.com domain' do
    VCR.use_cassette 'search API expect first email type == generic OR personal with stripe.com domain' do
      email_hunter = EmailHunter.new(key)
      expect(email_hunter.search('stripe.com').data.fetch(:emails).first[:type]).to eq('generic').or(eq('personal'))
    end
  end

  it 'expect alexis@reddit.com API finder email' do
    VCR.use_cassette 'expect alexis.ohanian@reddit.com API generate email' do
      email_hunter = EmailHunter.new(key)
      expect(email_hunter.finder('reddit.com', 'Alexis',
                                 'Ohanian').data.fetch(:email)).to eq('alexis@reddit.com')
    end
  end

  it 'expect email present' do
    VCR.use_cassette 'expect email present' do
      email_hunter = EmailHunter.new(key)
      expect(email_hunter.account.data.fetch(:email)).not_to be nil
    end
  end

  it 'expect Davide as first_name' do
    VCR.use_cassette 'expect email present' do
      email_hunter = EmailHunter.new(key)
      expect(email_hunter.account.data.fetch(:first_name)).to eq('Davide')
    end
  end

  it 'company API returns correct data for stripe.com' do
    VCR.use_cassette 'company API returns correct data for stripe.com' do
      email_hunter = EmailHunter.new(key)
      result = email_hunter.company('stripe.com')

      expect(result.data.name).to eq('Stripe')
      expect(result.data.description).not_to be_nil
      expect(result.data.foundedYear).to eq(2010)
      expect(result.data.site.emailAddresses).to be_an(Array)
      expect(result.data.tech).to be_an(Array)
      expect(result.meta.domain).to eq('stripe.com')
    end
  end

  it 'people API returns employee data for matt@hunter.io' do
    VCR.use_cassette 'people API returns employee data for matt@hunter.io' do
      email_hunter = EmailHunter.new(key)
      result = email_hunter.people('matt@hunter.io')

      # Verify overall structure
      expect(result.data).not_to be_nil
      expect(result.meta).not_to be_nil

      # Verify person data
      expect(result.data.name.fullName).to eq('Matthew Tharp')
      expect(result.data.name.givenName).to eq('Matthew')
      expect(result.data.name.familyName).to eq('Tharp')
      expect(result.data.email).to eq('matt@hunter.io')
      expect(result.data.employment.domain).to eq('hunter.io')
      expect(result.data.employment.name).to eq('Hunter')

      # Verify meta data
      expect(result.meta.email).to eq('matt@hunter.io')
    end
  end

  # ============================================
  # New v2.0.0 API Tests
  # ============================================

  describe 'Discover API' do
    it 'returns companies from natural language query' do
      VCR.use_cassette 'discover API returns companies' do
        email_hunter = EmailHunter.new(key)
        result = email_hunter.discover('Software companies in San Francisco')

        expect(result).not_to be_nil
        expect(result.data).to be_an(Array)
        expect(result.meta).not_to be_nil
        expect(result.meta.params.query).to eq('Software companies in San Francisco')
      end
    end
  end

  describe 'Leads API' do
    it 'lists leads successfully' do
      VCR.use_cassette 'leads API lists leads' do
        email_hunter = EmailHunter.new(key)
        result = email_hunter.leads(limit: 10)

        expect(result).not_to be_nil
        expect(result.data).not_to be_nil
        expect(result.meta).not_to be_nil
      end
    end

    it 'creates a lead successfully' do
      VCR.use_cassette 'leads API creates lead' do
        email_hunter = EmailHunter.new(key)
        lead_data = {
          email: 'test@example.com',
          first_name: 'Test',
          last_name: 'User',
          company: 'Example Inc'
        }
        result = email_hunter.lead_create(lead_data)

        expect(result).not_to be_nil
      end
    end
  end

  describe 'Campaigns API' do
    it 'lists campaigns successfully' do
      VCR.use_cassette 'campaigns API lists campaigns' do
        email_hunter = EmailHunter.new(key)
        result = email_hunter.campaigns(limit: 10)

        expect(result).not_to be_nil
        expect(result.data).not_to be_nil
      end
    end
  end

  describe 'Lead Enrichment API' do
    it 'enriches person data from email' do
      VCR.use_cassette 'lead enrichment API enriches person' do
        email_hunter = EmailHunter.new(key)
        result = email_hunter.lead_enrichment(email: 'matt@hunter.io')

        expect(result).not_to be_nil
        expect(result.data).not_to be_nil
        expect(result.data.email).to eq('matt@hunter.io')
        expect(result.data.name).not_to be_nil
        expect(result.meta).not_to be_nil
      end
    end

    it 'accepts LinkedIn handle as parameter' do
      VCR.use_cassette 'lead enrichment API with linkedin' do
        email_hunter = EmailHunter.new(key)
        result = email_hunter.lead_enrichment(linkedin: 'matttharp')

        expect(result).not_to be_nil
        expect(result.data).not_to be_nil
      end
    end
  end

  describe 'Company Enrichment API' do
    it 'enriches company data from domain' do
      VCR.use_cassette 'company enrichment API enriches company' do
        email_hunter = EmailHunter.new(key)
        result = email_hunter.company_enrichment('stripe.com')

        expect(result).not_to be_nil
        expect(result.data).not_to be_nil
        expect(result.data.name).to eq('Stripe')
        expect(result.data.domain).to eq('stripe.com')
        expect(result.meta).not_to be_nil
        expect(result.meta.domain).to eq('stripe.com')
      end
    end
  end

  describe 'Combined Enrichment API' do
    it 'returns both lead and company data' do
      VCR.use_cassette 'combined enrichment API returns full data' do
        email_hunter = EmailHunter.new(key)
        result = email_hunter.combined_enrichment(email: 'matt@hunter.io')

        expect(result).not_to be_nil
        expect(result.lead).not_to be_nil
        expect(result.lead.data).not_to be_nil
        expect(result.company).not_to be_nil
        expect(result.company.data).not_to be_nil
        expect(result.meta).not_to be_nil
        expect(result.meta.email).to eq('matt@hunter.io')
      end
    end
  end
end
