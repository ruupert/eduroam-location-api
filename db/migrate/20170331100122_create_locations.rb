class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :address
      t.integer :street_nr
      t.string :city
      t.string :country
      t.string :longitude
      t.string :latitude

      t.timestamps null: false
    end
  end
end
