require 'bundler'
Bundler.setup
require 'rubygems/package'
require "net/http"
require "dcf"
require 'open-uri'
require 'zlib'
require 'mongoid'
require 'kaminari/sinatra'
require 'sidekiq'
require 'sidetiq'
require "r_project/version"
require 'r_project/package_finder'
require 'r_project/package_information_extractor'
require 'r_project/package'
require 'workers/find_packages_worker'
require 'workers/fetch_description_worker'

ENV['RACK_ENV'] ||= 'development'

I18n.enforce_available_locales = false
Mongoid.load!(File.expand_path('../../config/mongoid.yml', __FILE__))

# handle large files getting package information; open uri buffer needs better buffer settings
OpenURI::Buffer.send :remove_const, 'StringMax'
OpenURI::Buffer.const_set 'StringMax', 0

module RProject
end