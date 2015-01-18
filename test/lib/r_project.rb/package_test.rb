require 'test_helper'

module RProject
  class PackageTest < Minitest::Test

    def test_description
      PackageInformationExtractor.expects(:new).with(package.name, package.version).returns( stub(extract!: { 'Title' => 'Package Title' } ))
      package.get_description
      package.reload
      assert_match 'Package Title', package.description['Title']
      assert package.done?
    end


    private
      
    def package
      @package ||= Package.new(name: "A3", version: '0.9.2')
    end

  end  
end