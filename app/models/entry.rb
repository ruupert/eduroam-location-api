class Entry < ActiveRecord::Base
  belongs_to :institution
  has_one :location
  has_many :loc_names
  has_one :orgssid
  accepts_nested_attributes_for :loc_names
end
