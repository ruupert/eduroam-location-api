class CreateOrgssids < ActiveRecord::Migration
  def change
    create_table :orgssids do |t|
      t.integer :number
      t.integer :wpa_tkip
      t.integer :wpa_aes
      t.integer :wpa2_tkip
      t.integer :wpa2_aes
      t.integer :port_restrict
      t.integer :transp_proxy
      t.integer :ipv6
      t.integer :nat
      t.integer :institution_id

      t.timestamps null: false
    end
  end
end
