class RenameLocationIdToEntryId < ActiveRecord::Migration
  def change
    rename_column :loc_names,:location_id,:entry_id
  end
end
