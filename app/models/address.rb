class Address < ActiveRecord::Base
  attr_accessible :text_block, :name_1, :name_2, :name_3, :street_number, :street_name, :unit_number, :city, :state, :zip_5, :zip_4
    
  validates :name_1,        presence: true
  validates :street_number, presence: true
  validates :street_name,   presence: true
  validates :city,          presence: true
  validates :state,         presence: true
  validates :zip_5,         presence: true
  
end
