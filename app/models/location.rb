class Location < ActiveRecord::Base
  has_many :entries
end
