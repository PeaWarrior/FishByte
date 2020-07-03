class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :water
      t.integer :acres_mile
      t.string :fish_species 
    end
  end
end
