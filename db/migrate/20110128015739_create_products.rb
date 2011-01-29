class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :code
      t.integer :catalog_id
      t.integer :category_id
      t.string :description
      t.decimal :unit_price

      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
