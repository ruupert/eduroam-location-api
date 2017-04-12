require 'google_maps_service'
class GMapHandler
  def self.getCoordinates(address, city)
    gmaps = GoogleMapsService::Client.new(key: self.gkey)
    results = gmaps.geocode("#{address}, #{city}")
    # and I get a crap array that does not respond to any sane access methods presented by documentation...
    # 3 hours of wtf:ing
    # so fuck this array'o'clock:
    split = results.to_s.split("geometry")[1].split("location_type")[0].split(", :")
    # And here we have our values....... in 5 minutes.... piece of crap rails
    lng = split[1].match(/[+-]?([0-9]*[.])?[0-9]+/)[0]
    lat = split[0].match(/[+-]?([0-9]*[.])?[0-9]+/)[0]

    # and now we can convert coordinates to Degrees-Minutes-Seconds:
    dmslng = deg2dms(lng,'lng')
    dmslat = deg2dms(lat,'lat')
    

  end

  def self.deg2dms(coord, type)

    case type
      when 'lng'
        if coord < 0
          coord = coord.abs
          sign = 'W'
        else
          sign = 'E'
        end

      when 'lat'
        if coord < 0
          coord = coord.abs
          sign = 'S'
        else
          sign = 'N'
        end
    end
    remainder = coord.to_f % 1
    intval = coord.to_i
    degrees = intval.to_s

    coord = remainder * 60;
    remainder = coord % 1
    intval = coord.to_i
    if (intval < 0)
      intval = intval * -1
    end
    minutes = intval.to_s
    coord = remainder * 60
    intval = coord.to_i
    if (intval<0)
      intval = intval * -1
    end
    seconds = intval.to_s

    return "#{degrees}°#{minutes}′#{seconds}″#{sign}"


  end
  private

  def self.gkey
      raise "GAPIKEY env variable not defined" if ENV['GAPIKEY'].nil?
      ENV['GMAPKEY']
    end
  end