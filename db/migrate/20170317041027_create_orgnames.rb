class CreateOrgnames < ActiveRecord::Migration
  def change
    create_table :orgnames do |t|
      t.string :lang
      t.string :name
      t.integer :institution_id

      t.timestamps null: false
    end
  end
end
