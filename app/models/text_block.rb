class TextBlock < ActiveRecord::Base
    attr_accessible :text
    has_one :address

    validates :text, presence: true
  
end
