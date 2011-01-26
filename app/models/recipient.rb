class Recipient
  include ActiveModel::Validations  
  include ActiveModel::Conversion  
  extend ActiveModel::Naming  

  attr_accessor :name, :email, :phone, :address, :city
    
  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :phone
  validates_presence_of :city
  
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :allow_blank => true
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end