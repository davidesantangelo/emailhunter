# frozen_string_literal: true

require 'spec_helper'
require 'vcr'

describe EmailHunter do
  let(:key) { 'd6195427a0ece5ce56afc2392374f095a98a4bb1' }

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

  it 'people API returns employee data for patrick@stripe.com' do
    VCR.use_cassette 'people API returns employee data for patrick@stripe.com' do
      email_hunter = EmailHunter.new(key)
      result = email_hunter.people('patrick@stripe.com')
      
      # Verify overall structure
      expect(result.data).not_to be_nil
      expect(result.meta).not_to be_nil
      
      # Verify person data
      expect(result.data.name.fullName).to eq('Patrick Roide')
      expect(result.data.name.givenName).to eq('Patrick')
      expect(result.data.name.familyName).to eq('Roide')
      expect(result.data.email).to eq('patrick@stripe.com')
      expect(result.data.timeZone).to eq('America/Denver')
      expect(result.data.employment.domain).to eq('stripe.com')
      expect(result.data.employment.name).to eq('Stripe')
      expect(result.data.employment.title).to eq('Account Executive')
      
      # Verify meta data
      expect(result.meta.email).to eq('patrick@stripe.com')
    end
  end
end
