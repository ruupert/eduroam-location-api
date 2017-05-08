class Orgname < ActiveRecord::Base
  belongs_to :institution
  validates :name, :lang, presence: true
  validates_uniqueness_of :lang, :scope => [:institution_id, :name], :message => 'Same language already exists!'
end
