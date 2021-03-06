require 'test_helper'

class FetchDescriptionWorkerTest < Minitest::Test

  def setup
    fixture_file_path =  File.expand_path('../../..', __FILE__) + '/fixtures/A3_0.9.2.tar.gz'
    stub_request(:get, /http:\/\/cran(\..*)?\.r-project\.org\/src\/contrib\/A3_0\.9\.2\.tar\.gz/).
      to_return(:status => 200, :body => File.open(fixture_file_path) )       
    worker.perform(version.id)
    version.reload
  end

  def test_perform
    assert version.done?, "Version state is not done is #{version.state}"
  end

  def test_decription_fetched
    refute_empty version.raw_version_information
  end

  def test_authors_set
    refute_empty version.authors
  end

  def test_maintainers_set
    refute_empty version.maintainers
  end

  def test_no_extra_person_created
    assert_equal 1, RProject::Person.count
  end

  private

  def package
    @package ||= RProject::Package.create(name: 'A3')    
  end

  def version
    @version ||= RProject::Version.create(number: '0.9.2', package: package)
  end

  def worker
    @worker ||= FetchDescriptionWorker.new
  end

end