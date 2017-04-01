class RemovePwhashFromInstitution < ActiveRecord::Migration
  def change
    remove_column :institutions,:pw_hash
  end
end
