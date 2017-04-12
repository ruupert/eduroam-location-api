class CreateLocNames < ActiveRecord::Migration
  def change
    create_table :loc_names do |t|
      t.string :lang
      t.string :name
      t.integer :location_id

      t.timestamps null: false
    end
  end
end
