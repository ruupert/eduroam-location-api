class Location < ActiveRecord::Base
  has_many :entries
  has_many :loc_names
  belongs_to :institution

  def self.create_location(institution_id, address, identifier, city)
    g = GMapHandler.new(address, city)
    if g.valid?
      n = Location.new
      n.institution_id = institution_id
      n.address = g.address
      n.city = g.city
      n.identifier = identifier
      n.latitude = g.lat
      n.longitude = g.lng
      n.country = g.country
      n.save
      n.loc_names.build
      ## implement here the english name...
      n.loc_names.last.name=n.address
      n.loc_names.last.lang= 'en'
      n.save
      return n.id
    end
  end
  def location_entry
    self.entries.getEntry(self.id)
  end

  def location_ap_count
    self.location_entry.first.ap_count
  end
  def location_updated_At
    self.location_entry.first.updated_at
  end

  def self.get_location_id(institution_id, address, identifier, city)
    return Location.where(institution_id: institution_id, address: address, identifier: identifier, city: city).first.id
  end
end
