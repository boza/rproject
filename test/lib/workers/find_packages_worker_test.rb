require 'test_helper'

class FindPackagesWorkerTest < Minitest::Test

  def setup
    fixture_file_path =  File.expand_path('../../..', __FILE__) + '/fixtures/A3_0.9.2.tar.gz'
    package
    version
    stub_request(:get, /http:\/\/cran(\..*)?\.r-project.org\/src\/contrib\/PACKAGES/).
      to_return(:status => 200, :body => <<-STRING
Package: A3
Version: 0.9.3
Depends: R (>= 2.15.0), xtable, pbapply
Suggests: randomForest, e1071
License: GPL (>= 2)
NeedsCompilation: no

Package: abc
Version: 2.0
Depends: R (>= 2.10), nnet, quantreg, MASS, locfit
License: GPL (>= 3)
NeedsCompilation: no

Package: abcdeFBA
Version: 0.4
Depends: Rglpk,rgl,corrplot,lattice,R (>= 2.10)
Suggests: LIM,sybil
License: GPL-2
NeedsCompilation: no

Package: ABCExtremes
Version: 1.0
Depends: SpatialExtremes, combinat
License: GPL-2
NeedsCompilation: no        
        STRING
        )
      stub_request(:get, /http:\/\/cran(\..*)?\.r\-project.org\/src\/contrib\/.*\.tar\.gz/).
    to_return(:status => 200, :body => File.open(fixture_file_path) )   
    worker.perform
  end

  def test_perform
    assert_equal 4, RProject::Package.count
  end

  def test_decription_fetched
    assert_equal 2, package.reload.versions.count
  end
  

  private

  def package
    @package ||= RProject::Package.create(name: 'A3')    
  end

  def version
    @version ||= RProject::Version.create(number: '0.9.2', package: package)
  end

  def worker
    @worker ||= FindPackagesWorker.new
  end

end