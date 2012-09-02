class Address < ActiveRecord::Base
  attr_accessible :name1, :name2, :name3, :address1, :address2, :city, :state, :zip5, :zip4
  belongs_to :text_block
end
