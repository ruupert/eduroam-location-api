class Entry < ActiveRecord::Base
  has_one :institution
  has_one :location
  has_one :orgssid
  def self.getEntry(id)
    return self.where(location_id: id).order(:id => :desc).limit(1)
  end

  def self.create_entry(institution_id,location_id, orgssid_id,ap_count)
    e = Entry.new
    e.institution_id=institution_id
    e.location_id=location_id
    e.orgssid_id=orgssid_id
    e.ap_count=ap_count
    e.save
  end

end
