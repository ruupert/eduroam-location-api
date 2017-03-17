class AddApikeyToInstitution < ActiveRecord::Migration
  def change
    add_column :institutions, :apikey, :string
    add_column :institutions, :pw_hash, :string
  end
end
