class FetchDescriptionWorker
  include Sidekiq::Worker

  def perform(id)
    version = RProject::Version.find(id)
    description_file_info = RProject::PackageInformationExtractor.extract!(version.package_name, version.number)
    version.raw_version_information = description_file_info.parsed_description
    #version.extract_mainteiners
    #version.extract_authors
    #version.extract_dependencies
    version.state = 'done'
    version.save!
  rescue
    version.update(state: 'error')
  end

end