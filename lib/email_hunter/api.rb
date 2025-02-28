# frozen_string_literal: true

require 'uri'

%w[exist search finder verify count account company people].each do |file|
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

    private

    # Helper method to reduce repetition
    def execute_hunt(klass, *args)
      case klass.name.split('::').last
      when 'Search'
        # Search expects (domain, key, params)
        domain, params = args
        klass.new(domain, key, params || {}).hunt
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
