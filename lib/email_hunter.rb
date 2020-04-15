# frozen_string_literal: true

require File.expand_path(File.join(File.dirname(__FILE__), 'email_hunter/api'))
require File.expand_path(File.join(File.dirname(__FILE__), 'email_hunter/version'))

module EmailHunter
  module_function

  def new(key)
    Api.new(key)
  end
end
