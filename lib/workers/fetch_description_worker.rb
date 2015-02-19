class FetchDescriptionWorker
  include Sidekiq::Worker

  def perform(id)
    version = RProject::Version.find(id)
    description_file_info = RProject::PackageInformationExtractor.extract!(version.package_name, version.number)
    version.raw_version_information = description_file_info.parsed_description
    
    description_file_info.extract_authors.each do |person|
      person = find_person(person)
      version.authors << person
      person.owned_packages << version
      person.save
    end

    description_file_info.extract_maintainers.each do |person|
      person = find_person(person)
      version.maintainers << person
      person.maintained_packages << version
      person.save
    end  

    version.raw_dependencies = description_file_info.raw_dependencies.map { |dependency|  { name: dependency.package_name, version: dependency.version } }
    version.state = 'done'
    version.save!
  rescue => e
    version.update(state: 'error')
    raise e if RProject.env == 'test'
  end

  def find_person(person_information)
    person = RProject::Person.find_or_create_by(name: person_information.name)
    # check if same person
    if person.email.present? && person.email != person_information.email
      person = RProject::Person.find_or_create_by(email: person_information.email).update(name: person_information.name)
    else
      person.update(email: person_information.email)  
    end
    person.is_a?(RProject::Person) ? person : nil
  end 

end