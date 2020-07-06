class RenameAgeToDobInUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :age, :dob
  end
end
