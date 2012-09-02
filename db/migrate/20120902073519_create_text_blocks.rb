class CreateTextBlocks < ActiveRecord::Migration
  def change
    create_table :text_blocks do |t|
      t.text :text

      t.timestamps
    end
  end
end
