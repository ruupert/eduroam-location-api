class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :institution_id
      t.integer :location_id
      t.integer :ap_count

      t.timestamps null: false
    end
  end
end
