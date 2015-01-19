class FindPackagesWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform
    RProject::PackageFinder.all.each do |package_info|
      package = RProject::Package.find_or_create_by(name: package_info['Package'])
      version = package.versions.find_or_create_by(number: package_info["Version"])
      version.fetch_description_file unless version.done?
    end
  end

end