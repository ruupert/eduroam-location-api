class AddOriginalImportStreetStringToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :orig_import_string,:string
  end
end
