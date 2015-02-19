class FetchDescriptionWorker
  include Sidekiq::Worker

  def perform(id)
    version = RProject::Version.find(id)
    description_file_info = RProject::PackageInformationExtractor.extract!(version.package_name, version.number)
    version.raw_version_information = description_file_info.parsed_description
    
    description_file_info.extract_authors.each do |person|
      person = find_person(person)
      version.authors << person
    end

    description_file_info.extract_maintainers.each do |person|
      person = find_person(person)
      version.maintainers << person
    end  

    version.raw_dependencies = description_file_info.raw_dependencies
    version.state = 'done'
    version.save!
  rescue => e
    version.update(state: 'error')
    raise e if RProject.env == 'test'
  end

  def find_person(person_information)
    person = RProject::Person.find_or_create_by(name: person_information.name)
    # check if same person
    if person.email.present?
      if person.email != person_information.email
        person = Person.find_by_or_create_by(email: person_information.email).update(name: person_information.name)
      end
    else
      person.update(email: person_information.email)  
    end  
    person  
  end

end