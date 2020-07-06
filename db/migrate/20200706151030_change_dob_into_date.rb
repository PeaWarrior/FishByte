class ChangeDobIntoDate < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :dob, :date
  end
end
