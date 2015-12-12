require 'spec_helper'
require 'vcr'

describe EmailHunter do
  let(:key) { "api key" }

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

  it 'verify API expect status \'success\'' do
  	VCR.use_cassette 'verify API expect status \'success\'' do
    	email_hunter = EmailHunter.new(key)
    	expect(email_hunter.verify('bonjour@firmapi.com').exist).to eq('success')
  	end
  end

  it 'search API expect first email type == personal with stripe.com domain' do
    VCR.use_cassette 'search API expect first email type == personal with stripe.com domain' do
      email_hunter = EmailHunter.new(key)
      expect(email_hunter.search('stripe.com').emails.first[:type]).to be == "personal"
    end
  end

  it 'expect davide.santangelo@gmail.com API generate email' do
  	VCR.use_cassette 'expect davide.santangelo@gmail.com API generate email' do
    	email_hunter = EmailHunter.new(key)
    	expect(email_hunter.generate('gmail.com', 'Davide', 'Santangelo').email).to eq('davide.santangelo@gmail.com')
  	end
  end
end
