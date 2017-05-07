class Entry < ActiveRecord::Base
  has_one :institution
  has_one :location
  has_one :orgssid
  #attr_accessor :location_id

  def self.getEntry(id)
    return self.where(location_id: id).order(:id => :desc).limit(1)
  end

  def self.create_entry(institution_id,loc_id, orgssid_id,ap_count)

    puts orgssid_id
    puts orgssid_id
    puts orgssid_id
    puts orgssid_id
    puts orgssid_id
    last = Entry.where(location_id: loc_id, institution_id: institution_id).last
    if last == nil
      new_entry_for_create_entryy(institution_id,loc_id, orgssid_id,ap_count)
    else

      if !last.ap_count == ap_count
        new_entry_for_create_entryy(institution_id,loc_id, last.orgssid_id,ap_count)
      end

    end
  end
  private
  def self.new_entry_for_create_entryy(institution_id,loc_id, orgssid_id,ap_count)
    e = Entry.new
    e.institution_id=institution_id
    e.location_id=loc_id
    e.orgssid_id=orgssid_id
    e.ap_count=ap_count
    e.save

  end
end
