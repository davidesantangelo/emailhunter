require 'spec_helper'
require 'vcr'

describe EmailHunter do
  it 'has a version number' do
    expect(EmailHunter::VERSION).not_to be nil
  end

  it 'search API expect status \'success\'' do
  	VCR.use_cassette 'search API expect status \'success\'' do
    	email = EmailHunter.new('Your secret API key')
    	expect(email.search('google.com').status).to eq('success')
  	end
  end

  it 'search API expect results > 0' do
  	VCR.use_cassette 'search API expect results > 0' do
    	email = EmailHunter.new('Your secret API key')
    	expect(email.search('google.com').results).to be > 0
  	end
  end

  it 'exists API expect status \'success\'' do
  	VCR.use_cassette 'exists API expect status \'success\'' do
    	email = EmailHunter.new('Your secret API key')
    	expect(email.exist('bonjour@firmapi.com').status).to eq('success')
  	end
  end

  it 'exists API expect status \'true\'' do
  	VCR.use_cassette 'exists API expect status \'true\'' do
    	email = EmailHunter.new('Your secret API key')
    	expect(email.exist('bonjour@firmapi.com').exist).to eq(true)
  	end
  end
end
