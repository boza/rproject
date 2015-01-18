class FindPackagesWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily }

  def perform
    RProject::PackageFinder.all.each do |package|
      package = RProject::Package.find_or_create_by(name: package['Package'], version: package['Version'])
      package.get_description unless package.done?
    end
  end

end