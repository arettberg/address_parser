class CreateAddresses < ActiveRecord::Migration
    def change
        create_table :addresses do |t|
            t.text :text_block
            t.string :name_1
            t.string :name_2
            t.string :name_3
            t.string :salutation
            t.string :suffix
            t.string :street_number
            t.string :street_name
            t.string :unit_number
            t.string :city
            t.string :state
            t.integer :zip_5
            t.integer :zip_4
            t.integer :text_block_id

            t.timestamps
        end
    end
end
