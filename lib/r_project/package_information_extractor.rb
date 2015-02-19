module RProject
  class PackageInformationExtractor
    
    attr_accessor :name, :version, :description

    def initialize(name, version)
      @name, @version = name, version
      @raw_description = ''
      @description = {}
    end

    def extract!
      if download_tar 
        @description = Dcf.parse(@raw_description).first
      end
    end

    def file_name
      @file_name ||= '%{name}_%{version}.tar.gz' % { name: name, version: version }
    end

    def download_tar
      open(RProject.packages_cran_url + file_name) do |remote_file|
        tar_extract = Gem::Package::TarReader.new(Zlib::GzipReader.open(remote_file))
        entry = tar_extract.find { |entry| entry.header.name =~ /DESCRIPTION/ }
        content = entry.read.encode("UTF-8", "binary", invalid: :replace, undef: :replace, replace: '')
        @raw_description = content
      end
    rescue Timeout::Error => e
      #$log.error "#{e.class}: #{e.message} with package #{name}. Try with next package..."
      "Error: #{e.class}: #{e.message} with package #{name}. Try with next package..."
      return
    end
  end  
end