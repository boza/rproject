module RProject
  class PackageFinder

    include Enumerable
    
    URL = "http://cran.r-project.org/src/contrib/PACKAGES"
    TMP_DIR = File.expand_path('../../../tmp', __FILE__)

    def self.all
      new(URL).tap do |finder|
        finder.get_packges
      end
    end

    def initialize(url)
      @uri = URI(url)
      @file = TMP_DIR + '/%s/response' % ENV['RACK_ENV']
    end

    def get_packges
      # write on file so is not kept in memory
      Net::HTTP.start(@uri.host) do |http|
        request = Net::HTTP::Get.new @uri

        http.request request do |response|
          open (@file), 'w' do |io|
            response.read_body do |chunk|
              io.write chunk
            end
          end
        end
      end      
    end

    def each
      packages.each do |package|
        yield(Dcf.parse(package)[0]) if block_given?
      end
    end

    def packages
      @packages ||= File.read(@file).split(/\n\n/)
    end

  end  
end