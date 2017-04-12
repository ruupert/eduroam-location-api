class AddSsidNameToOrgssid < ActiveRecord::Migration
  def change
    add_column :orgssids, :name, :string

  end
end
