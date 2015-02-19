require 'test_helper'

module RProject
  class PackageInformationExtractorTest < Minitest::Test

    def setup
      fixture_file_path =  File.expand_path('../../..', __FILE__) + '/fixtures/A3_0.9.2.tar.gz'
      stub_request(:get, /http:\/\/cran(\..*)?\.r\-project.org\/src\/contrib\/A3_0\.9\.2\.tar\.gz/).
        to_return(:status => 200, :body => File.open(fixture_file_path) )     
      package_extractor.extract!
    end

    def test_file_name
      assert_match 'A3_0.9.2.tar.gz', package_extractor.file_name
    end

    def test_failed_tar_extraction
      package_extractor = PackageInformationExtractor.new("A3", '0.9.2')
      package_extractor.expects(:download_tar).returns(nil)
      package_extractor.extract!
      assert_empty package_extractor.parsed_description
    end

    def test_parse_description
      refute_empty package_extractor.parsed_description
    end


    private

    def package_extractor
      @package_extractor ||= PackageInformationExtractor.new("A3", '0.9.2')
    end

  end  
end