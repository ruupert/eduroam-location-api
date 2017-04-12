class Location < ActiveRecord::Base
  has_many :entries
  has_many :loc_names
  belongs_to :institution
end
