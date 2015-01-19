module RProject
  class Package
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name
    has_many :versions, dependent: :destroy

    def latest_version_number
      latest_version.number
    end

    def title
      latest_version.title
    end

    def full_description
      latest_version.full_description
    end

    def date_publication
      latest_version.date_publication
    end

    def authors
      latest_version.authors
    end

    def maintainers
      latest_version.maintainers
    end

    def latest_version
      @latest_version ||= versions.last
    end

  end  
end