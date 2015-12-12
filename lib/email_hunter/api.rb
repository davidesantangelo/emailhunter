require 'uri'

require File.expand_path(File.join(File.dirname(__FILE__), 'search'))
require File.expand_path(File.join(File.dirname(__FILE__), 'exist'))
require File.expand_path(File.join(File.dirname(__FILE__), 'generate'))
require File.expand_path(File.join(File.dirname(__FILE__), 'verify'))

module EmailHunter
  class Api
    attr_reader :key

  	def initialize(key)
  		@key = key
  	end

    # Domain search API
  	def search(domain)
  		EmailHunter::Search.new(domain, self.key).hunt
  	end

    # Email Check API
  	def exist(email)
  		EmailHunter::Exist.new(email, self.key).hunt
  	end

    # Email Generate API
  	def generate(domain, first_name, last_name)
  		EmailHunter::Generate.new(domain, first_name, last_name, self.key).hunt
  	end

    def verify(email)
      EmailHunter::Verify.new(email, self.key).hunt
    end
  end
end
