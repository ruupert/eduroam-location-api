require 'google_maps_service'
class GMapHandler
  def initialize(address, city)
    @@results = GoogleMapsService::Client.new(key: gkey).geocode("#{address}, #{city}")
    if @@results.first.nil?
      @@valid = false
      @@address = ''
      @@city = ''
      @@country = ''
      @@lat = ''
      @@lng = ''
    else
      @@valid = true
      coordinates
      @@address = "#{@@results.first.first.second.second.first.second} #{@@results.first.first.second.first.first.second}"
      @@city = @@results.first.first.second.third.first.second.to_s
      @@country = @@results.first.first.second.fourth[:short_name]
    end
  end
  def valid?
    return @@valid
  end

  def address
    return @@address
  end
  def city
    return @@city
  end
  def country
    return @@country
  end

  def lng
    return @@lng
  end
  def lat
    return @@lat
  end
  def coordinates
    # and I get a crap array that does not respond to any sane access methods presented by documentation...
    # 3 hours of wtf:ing
    # so f*** this array'o'clock:
    split = @@results.to_s.split("geometry")[1].split("location_type")[0].split(", :")
    # And here we have our values....... in 5 minutes.... piece of crap rails
    lng = split[1].match(/[+-]?([0-9]*[.])?[0-9]+/)[0]
    lat = split[0].match(/[+-]?([0-9]*[.])?[0-9]+/)[0]


    # and now we can convert coordinates to Degrees-Minutes-Seconds:
    @@lng = deg2dms(lng,'lng')
    @@lat = deg2dms(lat,'lat')

  end

  def deg2dms(coord, type)

    case type
      when 'lng'
        if coord.to_f < 0
          coord = coord.to_f.abs
          sign = 'W'
        else
          sign = 'E'
        end

      when 'lat'
        if coord.to_f < 0
          coord = coord.to_f.abs
          sign = 'S'
        else
          sign = 'N'
        end
    end
    intval = coord.to_i
    degrees = intval.to_s

    coord = (coord.to_f % 1) * 60;
    intval = coord.to_i
    if (intval < 0)
      intval = intval * -1
    end
    minutes = intval.to_s
    coord = (coord % 1) * 60
    intval = coord.to_i
    if (intval<0)
      intval = intval * -1
    end
    seconds = intval + ( coord % 1 )

    return "#{degrees}°#{minutes}'#{seconds.round(2)}\"#{sign}"

  end

  def to_string
    return "#{self.address}#{self.city}#{self.lng}#{self.lat}#{self.country}#{self.valid?}"
  end

  def gkey
      raise "GMAPKEY env variable not defined" if ENV['GMAPKEY'].nil?
      ENV['GMAPKEY']
    end
  end