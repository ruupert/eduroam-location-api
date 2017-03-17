class CreateOrginfos < ActiveRecord::Migration
  def change
    create_table :orginfos do |t|
      t.string :lang
      t.string :url
      t.integer :institution_id

      t.timestamps null: false
    end
  end
end
