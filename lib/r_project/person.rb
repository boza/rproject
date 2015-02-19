module RProject
  class Person
    include Mongoid::Document
    include Mongoid::Timestamps
    
    field :name
    field :email
    field :confirmed


  end
end