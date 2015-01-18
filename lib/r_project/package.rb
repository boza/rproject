module RProject
  class Package
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name
    field :version
    field :description, type: Hash, default: {}
    field :state, type: String, default: 'new'

    def get_description
      update(state: 'downloading')
      FetchDescriptionWorker.perform_async(id.to_s)
    end

    def done?
      state == 'done'
    end

  end  
end