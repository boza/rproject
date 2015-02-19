require 'test_helper'

module RProject
  class PackageFinderTest < Minitest::Test

    def setup
      stub_request(:get, "http://cran.r-project.org/src/contrib/PACKAGES").
        to_return(:status => 200, :body => <<-STRING
Package: A3
Version: 0.9.2
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
    
      package_finder.get_packges
    end


    def test_packages
      assert_equal 4, package_finder.packages.count
    end

    def test_packages_parsing
      assert_match 'A3', package_finder.first['Package']
    end

    private

    def package_finder
      @package_finder ||= PackageFinder.new
    end

  end  
end