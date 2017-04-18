class Api::V1::LocationsSerializer < Api::V1::BaseSerializer
  attributes :id, :address, :identifier, :city, :country, :longitude, :latitude
end