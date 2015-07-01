require 'spec_helper'
require 'vcr'

describe EmailHunter do
  let(:key) { "50204eb5ba5712bf2733b567355b8f91881e224d" }

  it 'has a version number' do
    expect(EmailHunter::VERSION).not_to be nil
  end

  it 'search API expect status \'success\'' do
  	VCR.use_cassette 'search API expect status \'success\'' do
    	email_hunter = EmailHunter.new(key)
    	expect(email_hunter.search('google.com').status).to eq('success')
  	end
  end
  
  it 'search API expect results > 0' do
  	VCR.use_cassette 'search API expect results > 0' do
    	email_hunter = EmailHunter.new(key)
    	expect(email_hunter.search('google.com').results).to be > 0
  	end
  end

  it 'search API expect offset == 0 with stripe.com domain' do
    VCR.use_cassette 'search API expect status \'success\'' do
      email_hunter = EmailHunter.new(key)
      expect(email_hunter.search('stripe.com').offset).to be == 0
    end
  end

  it 'exists API expect status \'success\'' do
  	VCR.use_cassette 'exists API expect status \'success\'' do
    	email_hunter = EmailHunter.new(key)
    	expect(email_hunter.exist('bonjour@firmapi.com').status).to eq('success')
  	end
  end

  it 'exists API expect status \'true\'' do
  	VCR.use_cassette 'exists API expect status \'true\'' do
    	email_hunter = EmailHunter.new(key)
    	expect(email_hunter.exist('bonjour@firmapi.com').exist).to eq(true)
  	end
  end

  it 'search API expect first email type == personal with stripe.com domain' do
    VCR.use_cassette 'search API expect first email type == personal with stripe.com domain' do
      email_hunter = EmailHunter.new(key)
      expect(email_hunter.search('stripe.com').emails.first[:type]).to be == "personal"
    end
  end
end
