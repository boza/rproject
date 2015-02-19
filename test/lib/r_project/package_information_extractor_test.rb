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

    def test_dependency_extraction
      expected_dependencies = [ {name: 'R' ,version: '>= 2.15.0'}, {name: 'pbapply', version: '> 0.0.0'}, {name: 'xtable', version: '> 0.0.0'} ]
      dependencies = package_extractor.raw_dependencies.sort_by { |x, y| x[:name] <=> y[:name] } 
      assert_equal expected_dependencies, dependencies
    end

    def test_parse_description
      refute_empty package_extractor.parsed_description
    end

    def test_author_extraction
      extractor = PackageInformationExtractor.new("A3", '0.9.2')
      extractor.stubs(:parsed_description).returns( { "Author" => "Test1 LastName <test@test.com>,, Test2 and Test3" })
      authors = extractor.extract_authors
      assert_equal 3, authors.size
      p authors
      assert_match "test@test.com", authors.first.email
      assert_match "Test1 LastName", authors.first.name
    end

    def test_maintaner_extraction
      extractor = PackageInformationExtractor.new("A3", '0.9.2')
      extractor.stubs(:parsed_description).returns( { "Maintainer" => "Test1 <test@test.com>, Test2 and Test3" })
      assert_equal 3, extractor.extract_maintainers.size      
    end


    private

    def package_extractor
      @package_extractor ||= PackageInformationExtractor.new("A3", '0.9.2')
    end

  end  
end