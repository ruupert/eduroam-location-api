class Orgssid < ActiveRecord::Base
  belongs_to :institution
  has_many :entries

  #before_update :next_num

  #private
  def next_num
    self.number = Orgssid.where(institution_id: self.institution_id).maximum(:number).to_i + 1
  end


end

