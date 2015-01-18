require 'rake/testtask'
require_relative 'app'

task default: :test

Rake::TestTask.new(:test) do |test|
  test.libs << "test" # here is the test_helper
  test.pattern = "test/**/*_test.rb"
end

