class Address < ActiveRecord::Base
  attr_accessible :text_block, :name_1, :name_2, :name_3, :street_number, :street_name, :unit_number, :po_box, :city, :state, :zip_5, :zip_4, :care_of, :unit_name
    
  validates :name_1,        presence: true
  validates :street_number, presence: {unless: :po_box, message: "and name or PO Box must be given"}
  validates :street_name,   presence: {unless: :po_box, message: "and number or PO Box must be given"}
  validates :po_box,        presence: {unless: :street_number, message: "or street name/number must be given"}
  validates :city,          presence: true
  validates :state,         presence: true
  validates :zip_5,         presence: true
  
end
