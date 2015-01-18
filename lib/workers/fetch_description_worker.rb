class FetchDescriptionWorker
  include Sidekiq::Worker

  def perform(id)
    package = RProject::Package.find(id)
    description = RProject::PackageInformationExtractor.new(package.name, package.version).extract!
    package.update(description: description, state: 'done')
  rescue
    package.update(state: 'error')
  end

end