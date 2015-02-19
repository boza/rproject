module RProject
  class Person
    include Mongoid::Document
    include Mongoid::Timestamps
    
    field :name
    field :email
    field :confirmed

    has_and_belongs_to_many :maintained_packages, inverse_of: :maintainers
    has_and_belongs_to_many :owned_packages, inverse_of: :authors


  end
end