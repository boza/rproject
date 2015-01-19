 ENV['RACK_ENV'] = 'test'
require 'bundler'
Bundler.setup
require File.join(File.dirname(__FILE__), *%w[.. lib r_project])
require 'minitest/autorun'
require 'active_support/testing/assertions'
require 'active_support/testing/time_helpers'
require 'mocha/mini_test'
require 'webmock/minitest'
require 'sidekiq/testing'

Sidekiq::Testing.inline!

class Minitest::Test
  include ActiveSupport::Testing::Assertions
  include ActiveSupport::Testing::TimeHelpers

  def teardown
    ::Mongoid.purge!
  end

end