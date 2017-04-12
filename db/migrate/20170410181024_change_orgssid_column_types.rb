class ChangeOrgssidColumnTypes < ActiveRecord::Migration
  def change
    remove_column :orgssids, :port_restrict
    remove_column :orgssids, :transp_proxy
    remove_column :orgssids, :ipv6
    remove_column :orgssids, :nat
    remove_column :orgssids, :wpa_tkip
    remove_column :orgssids, :wpa_aes
    remove_column :orgssids, :wpa2_tkip
    remove_column :orgssids, :wpa2_aes
    add_column :orgssids, :port_restrict, :boolean
    add_column :orgssids, :transp_proxy, :boolean
    add_column :orgssids, :ipv6, :boolean
    add_column :orgssids, :nat, :boolean
    add_column :orgssids, :wpa_tkip, :boolean
    add_column :orgssids, :wpa_aes, :boolean
    add_column :orgssids, :wpa2_tkip, :boolean
    add_column :orgssids, :wpa2_aes, :boolean
    add_column :orgssids, :wired, :boolean

  end
end
