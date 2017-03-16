class CreateInstitutions < ActiveRecord::Migration
  def change
    create_table :institutions do |t|
      t.string :country
      t.integer :institution_type
      t.string :inst_realm
      t.string :address
      t.string :city
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone

      t.timestamps null: false
    end
  end
end
