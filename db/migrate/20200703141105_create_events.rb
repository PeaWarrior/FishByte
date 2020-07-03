class CreateEvents < ActiveRecord::Migration[5.2]
  def change 
    create_table :events do |t|
      t.integer :user_id
      t.integer :location_id
      t.datetime :date
      t.integer :price
    end
  end
end
