 ENV['RACK_ENV'] ||= 'test'
require 'bundler'
Bundler.setup
require File.join(File.dirname(__FILE__), *%w[.. lib r_project])
require 'minitest/autorun'
require 'mocha/mini_test'
require 'webmock/minitest'
require 'sidekiq/testing'

Sidekiq::Testing.inline!