class AddSsidIdToEntry < ActiveRecord::Migration
  def change
    add_column :entries,:orgssid_id,:integer
  end
end
