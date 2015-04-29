require 'uri'

require File.expand_path(File.join(File.dirname(__FILE__), 'search'))
require File.expand_path(File.join(File.dirname(__FILE__), 'exist'))

module EmailHunter
  class Api
    attr_reader :key
    
  	def initialize(key)
  		@key = key
  	end

  	def search(domain)
  		EmailHunter::Search.new(domain, self.key).hunt
  	end

  	def exist(email)
  		EmailHunter::Exist.new(email, self.key).hunt
  	end
  end
end