class RemoveEntryIdFromLocName < ActiveRecord::Migration
  def change
    remove_column :loc_names,:entry_id
    add_column :loc_names, :location_id, :integer
    add_column :locations, :institution_id, :integer
  end
end
