class CreateOrgpolicies < ActiveRecord::Migration
  def change
    create_table :orgpolicies do |t|
      t.string :lang
      t.string :url
      t.integer :institution_id

      t.timestamps null: false
    end
  end
end
