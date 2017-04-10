class Entry < ActiveRecord::Base
  has_one :institution
  has_one :location
  has_one :orgssid
end
