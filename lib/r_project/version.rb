module RProject
  class Version
    include Mongoid::Document
    include Mongoid::Timestamps
    
    field :number
    field :raw_version_information, type: Hash, default: {}
    field :state, type: String, default: 'new'
    field :raw_dependencies, type: Array

    belongs_to :package

    has_and_belongs_to_many :maintainers, class_name: 'RProject::Person'
    has_and_belongs_to_many :authors, class_name: 'RProject::Person'

    delegate :name, to: :package, prefix: true

    def title
      raw_version_information['Title']
    end

    def full_description
      raw_version_information['Description']
    end

    def date_publication
      raw_version_information['Date/Publication']
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