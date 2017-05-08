require 'rails_helper'

RSpec.describe Entry, type: :model do
  describe "entry" do
    before(:each) do
      Entry.create_entry(1,1,1,15)

    end
    it "creates a new entry" do
      e = Entry.find(1)
      expect(e.institution_id).to eq(1)
      expect(e.location_id).to eq(1)
      expect(e.orgssid_id).to eq(1)
      expect(e.ap_count).to eq(15)
      expect(Entry.all.count).to eq(1)
    end
  end

end
