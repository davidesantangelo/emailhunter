require 'uri'

require File.expand_path(File.join(File.dirname(__FILE__), 'search'))
require File.expand_path(File.join(File.dirname(__FILE__), 'exist'))

module EmailHunter
  class Api
  	def initialize(key)
  		@key = key
  	end

  	def search(domain)
  		EmailHunter::Search.new(domain, @key).hunt
  	end

  	def exist(email)
  		EmailHunter::Exist.new(email, @key).hunt
  	end
  end
end