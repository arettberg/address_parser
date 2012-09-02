class CreateAddresses < ActiveRecord::Migration
    def change
        create_table :addresses do |t|
            t.string :name1
            t.string :name2
            t.string :name3
            t.string :salutation
            t.string :suffix
            t.string :address1
            t.string :address2
            t.string :city
            t.string :state
            t.integer :zip_5
            t.integer :zip_4
            t.integer :text_block_id

            t.timestamps
        end
    end
end
