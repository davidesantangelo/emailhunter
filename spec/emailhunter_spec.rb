require 'spec_helper'
require 'vcr'

describe EmailHunter do
  let(:key) { "2d2dc7bec84922e9d07495d03582185e95a6396f" }

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
end
