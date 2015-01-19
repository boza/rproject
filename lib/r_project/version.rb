module RProject
  class Version
    include Mongoid::Document
    include Mongoid::Timestamps
    
    field :number
    field :version_information, type: Hash, default: {}
    field :state, type: String, default: 'new'

    belongs_to :package

    delegate :name, to: :package, prefix: true

    def title
      version_information['Title']
    end

    def full_description
      version_information['Description']
    end

    def date_publication
      version_information['Date/Publication']
    end

    def authors
      version_information['Author']
    end

    def maintainers
      version_information['Maintainer']
    end

    def done?
      state == 'done'
    end

    def fetch_description_file
      update(state: 'downloading')
      FetchDescriptionWorker.perform_async(id.to_s)
    end

  end
end