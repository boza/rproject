module RProject
  class DependencyParser

    attr_accessor :package_name, :version
    
    def self.run(string)
      new(string).tap do |parser|
        parser.parse
      end
    end

    def initialize(string)
      @string = string
    end

    def parse
      parse_version
      parse_package_name
    end

    def parse_version
      matched_version = @string.match(/\((.*)\)/)
      @version = matched_version ? matched_version[1] : nil
    end

    def parse_package_name
      return @package_name = @string unless version
      name_match = @string.match(/(.*)\s\(/)
      @package_name = name_match ? name_match[1] : nil

    end

  end
end