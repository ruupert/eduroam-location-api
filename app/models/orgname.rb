class Orgname < ActiveRecord::Base
  belongs_to :institution
  validates :name, :lang, presence: true

end
