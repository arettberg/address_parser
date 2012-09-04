class CreateAddresses < ActiveRecord::Migration
    def change
        create_table :addresses do |t|
            t.text :text_block
            t.string :name_1
            t.string :name_2
            t.string :name_3
            t.string :care_of
            t.string :salutation
            t.string :suffix
            t.integer :street_number
            t.string :street_name
            t.string :unit_name
            t.integer :unit_number
            t.integer :po_box
            t.string :city
            t.string :state
            t.integer :zip_5
            t.integer :zip_4

            t.timestamps
        end
    end
end
