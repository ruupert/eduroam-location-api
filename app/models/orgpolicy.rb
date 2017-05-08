class Orgpolicy < ActiveRecord::Base
  belongs_to :institution
  validates_uniqueness_of :lang, :scope => [:institution_id, :url], :message => 'Same language already exists!'
end
