# frozen_string_literal: true

require 'uri'

require File.expand_path(File.join(File.dirname(__FILE__), 'exist'))
require File.expand_path(File.join(File.dirname(__FILE__), 'search'))
require File.expand_path(File.join(File.dirname(__FILE__), 'finder'))
require File.expand_path(File.join(File.dirname(__FILE__), 'verify'))
require File.expand_path(File.join(File.dirname(__FILE__), 'count'))
require File.expand_path(File.join(File.dirname(__FILE__), 'account'))

module EmailHunter
  class Api
    attr_reader :key

    def initialize(key)
      @key = key
    end

    # Domain search API
    def search(domain, params = {})
      EmailHunter::Search.new(domain, key, params).hunt
    end

    # Email exist API
    def exist(email)
      EmailHunter::Exist.new(email, key).hunt
    end

    # Email verify API
    def verify(email)
      EmailHunter::Verify.new(email, key).hunt
    end

    # Email Finder API
    def finder(domain, first_name, last_name)
      EmailHunter::Finder.new(domain, first_name, last_name, key).hunt
    end

    # Email Count API
    def count(domain)
      EmailHunter::Count.new(domain).hunt
    end

    # Account Information API
    def account
      EmailHunter::Account.new(key).hunt
    end
  end
end
