class ChangedWaterToCountyInLocationsTable < ActiveRecord::Migration[5.2]
  def change
    rename_column :locations, :water, :county
  end
end
