class RemoveStreetNrFromLocationAndAddBuildingIentifier < ActiveRecord::Migration
  def change
    remove_column :locations,:street_nr
    add_column :locations, :identifier,:string
  end
end
