class FetchDescriptionWorker
  include Sidekiq::Worker

  def perform(id)
    version = RProject::Version.find(id)
    description_file_info = RProject::PackageInformationExtractor.new(version.package_name, version.number).extract!
    version.update(version_information: description_file_info, state: 'done')
    
  rescue
    version.update(state: 'error')
  end

end