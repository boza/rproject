require 'test_helper'

module RProject
  class PackageTest < Minitest::Test

    def setup
      package.versions.create(number: '1.0.0')
    end

    def test_delegation
      assert_equal '1.0.0', @package.latest_version_number
    end


    private
      
    def package
      @package ||= Package.create(name: "A3")
    end

  end  
end