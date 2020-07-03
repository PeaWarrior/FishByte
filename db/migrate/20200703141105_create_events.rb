class CreateEvents < ActiveRecord::Migration[5.2]
  def change 
    create_table :events do |t|
      t.string :name
      t.datetime :date
      t.float :price
      t.integer :user_id
      t.integer :location_id
    end
  end
end
