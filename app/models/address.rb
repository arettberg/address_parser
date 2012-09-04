class Address < ActiveRecord::Base
  attr_accessible :text_block, :name_1, :name_2, :name_3, :street_number, :street_name, :unit_number, :po_box, :city, :state, :zip_5, :zip_4, :care_of, :unit_name
    
  # validates :name_1,        presence: true
  # validates :street_number, presence: {unless: :po_box, message: "You must enter at least one of the following: numbered street address or numbered po box"}
  # validates :street_name,   presence: {unless: :po_box, message: "You must enter at least one of the following: numbered street address or numbered po box"}
  # validates :po_box,        presence: {unless: :street_number, message: "You must enter at least one of the following: numbered street address or numbered po box"}
  # validates :city,          presence: true
  # validates :state,         presence: true
  # validates :zip_5,         presence: true
  
end
