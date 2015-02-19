module RProject
  class NameEmailParser
  
    attr_accessor :name, :email

    def self.run(string)
      new(string).tap do |parser|
        parser.parse!
      end
    end

    def initialize(string)
      @string = string
    end

    def parse!
      extract_email 
      extract_name
    end

    def extract_email
      email_match = @string.match(/<(.*)>/)
      @email = email_match ? email_match[1] : nil      
    end

    def extract_name
      return @name = @string unless email
      name_match = @string.match(/(.*)\s</)
      @name = name_match ? name_match[1] : nil
    end

  end
end