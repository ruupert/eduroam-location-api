module InstitutionsHelper

  def import_data
    q = Queue.new
    o = OpenStruct.new(Hash.from_xml(File.read("lib/assets/haagahelia2.xml")))

    doc = Nokogiri::XML(File.open("lib/assets/haagahelia2.xml")) do |config|
      config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NOBLANKS
    end
    doc.search("[lang]").each do |s|
      q.push(s['lang'])
    end
    o['institutions']['institution'].each do |x|
      n = Institution.new
      n.country = x['country']
      n.inst_realm = x['inst_realm']
      n.contact_name = x['contact']['name']
      n.contact_email = x['contact']['email']
      n.contact_phone = x['contact']['phone']
      n.institution_type = x['type'].to_i
      n.address = x['address']['street']
      n.city = x['address']['city']
      x['org_name'].each do |org|
        n.orgnames.build
        n.orgnames.last.name = org || " "
        n.orgnames.last.lang = q.pop
      end

      x['policy_URL'].each do |org|
        n.orgpolicies.build
        n.orgpolicies.last.url = org
        n.orgpolicies.last.lang = q.pop
      end

      x['info_URL'].each do |org|
        n.orginfos.build
        n.orginfos.last.url = org
        n.orginfos.last.lang = q.pop
      end
      x['location'].first do |ssid|  # Purkkaa
        n.orgssids.build
        n.orgssids.first.name = ssid['SSID']



      end
      x['location'].each do |item|
        n.locations.build
        n.locations.last.address = item['address']['street']
        n.locations.last.city = item['address']['city']
        n.locations.last.country = item['address']['country']
        n.locations.last.longitude = item['longitude']
        n.locations.last.latitude = item['latitude']
        item['loc_name'].each do |lname|
          n.locations.last.loc_names.build
          n.locations.last.loc_names.last.name = lname
          n.locations.last.loc_names.last.lang = q.pop
        end

        n.orgssids.build
        n.orgssids.last.name = item['SSID']
        n.orgssids.last.port_restrict = item['port_restrict']
        n.orgssids.last.ipv6 = item['IPv6']
        n.orgssids.last.nat = item['NAT']
        n.orgssids.last.transp_proxy = item['transp_proxy']
        n.orgssids.last.wired = item['wired']
        n.orgssids.last.port_restrict = false
        n.orgssids.last.transp_proxy = false
        n.orgssids.last.ipv6 = false
        n.orgssids.last.nat = false
        n.orgssids.last.wpa2_aes = false
        n.orgssids.last.wpa2_tkip = false
        n.orgssids.last.wpa_tkip = false
        n.orgssids.last.wpa_aes = false
        enc_str = item['enc_level'].to_s
        puts enc_str
        if enc_str.include? "WPA2/AES"
          n.orgssids.last.wpa2_aes = true
        end
        if enc_str.include? "WPA2/TKIP"
          n.orgssids.last.wpa2_tkip = true
        end
        if enc_str.include? "WPA/TKIP"
          n.orgssids.last.wpa_tkip = true
        end
        if enc_str.include? "WPA/AES"
          n.orgssids.last.wpa_aes = true
        end

        n.save
        n.entries.build
        n.entries.last.location_id = n.locations.last.id
        n.entries.last.orgssid_id = n.orgssids.last.id
        n.entries.last.institution_id = n.id

        n.entries.last.ap_count = item['AP_no']
        n.save

      end
      pp n.orgssids
      puts n.inspect
      distinctSSIDs = Orgssid.group(:institution_id, :name,:port_restrict,:transp_proxy,:ipv6,:nat,:wpa_tkip,:wpa_aes,:wpa2_tkip,:wpa2_aes,:wired).select('id,institution_id')

    end
    Entry.all.each do |e|
      b = Orgssid.find(e['id'])
      distinctSSIDs = Orgssid.where(institution_id: b['institution_id']).group(:institution_id,
                                                                               :name,
                                                                               :port_restrict,
                                                                               :transp_proxy,
                                                                               :ipv6,
                                                                               :nat,
                                                                               :wpa_tkip,
                                                                               :wpa_aes,
                                                                               :wpa2_tkip,
                                                                               :wpa2_aes,
                                                                               :wired).select('id,institution_id')
      u = Entry.find(e['id'])
      u.orgssid_id = distinctSSIDs.last.id
      u.save

    end
    Orgssid.where(["id NOT IN (?)", Entry.pluck("orgssid_id")]).destroy_all


  end

  def import_data2 import_file
    doc = Nokogiri::XML(File.open("lib/assets/haagahelia2.xml")) do |config|
      config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NOBLANKS
    end

    institutions = doc.xpath('//institutions')

    institutions.each do |institution|
      temp = Institution.new
      # puts "country: #{institution.css('country').children}"
      temp.country = institution.css('country').children

      #puts "type: #{institution.css('type').children}"
      temp.institution_type = institution.css('type').children

      #puts "realm: #{institution.css('inst_realm').children}"
      temp.inst_realm = "#{institution.css('inst_realm').children}"

      address = institution.css('institution address')
      #puts "street: #{address.css('street').children}"
      temp.address = address.css('street').children

      #puts "city: #{address.css('city').children}"
      temp.city = address.css('city').children

      contact = institution.css('institution contact')
      # puts "c name: #{contact.css('name').children}"
      temp.contact_name = contact.css('name').children

      #puts "c email: #{contact.css('email').children}"
      temp.contact_email = contact.css('email').children

      #puts "c phone: #{contact.css('phone').children}"
      temp.contact_phone = contact.css('phone').children

      #puts "ts: #{institution.css('institution ts').children}"

      pp temp

      temp.save

      institutionID = temp.id

      orgnames = institution.css('org_name')
      orgnames.each do |org|
#      temp = Orgname.new
#     temp.name = org.child
#   puts "org name: #{org.child}"
        org.each { |attr_name, attr_value|
          #      temp.lang = attr_value
          #    puts "#{attr_name} -> #{attr_value}"
        }
#   temp.institution_id = institutionID
#   temp.save
      end
      info_url = institution.css('institution info_URL')
      info_url.each do |info|
        #  temp = Orginfo.new
        #  temp.url = info.child
        #   puts "info url: #{info.child}"
        info.each { |attr_name, attr_value|
          #   temp.lang = attr_value
          #    puts "#{attr_name} -> #{attr_value}"
        }
        #  temp.institution_id = institutionID
        #      temp.save

      end
      policy_url = institution.css('institution policy_URL')
      policy_url.each do |policy|
#      temp = Orgpolicy.new
#     temp.url = policy.child
#  puts "policy url: #{policy.child}"
        info.each { |attr_name, attr_value|
          #      temp.lang = attr_value
          #   puts "#{attr_name} -> #{attr_value}"
        }
#  temp.institution_id = institutionID
#   temp.save

      end

      locations = institution.css('location')
      locations.each do |location|
        #  puts "longitude: #{location.css('longitude').children}"
        #  puts "latitude: #{location.css('latitude').children}"
        location.css('loc_name').each do |loc_name|
          #   puts "loc_name #{loc_name.child}"
          loc_name.each { |attr_name, attr_value|
            #    puts "#{attr_name} -> #{attr_value}"
          }
        end
        location.css('address').each do |address|
          #    puts "street: #{address.css('street').children}"
          #    puts "city: #{address.css('city').children}"
        end
        #  puts "SSID: #{location.css('SSID').children}"
        #  puts "enc_level: #{location.css('enc_level').children}"
        #  puts "port_restrict: #{location.css('port_restrict').children}"
        #  puts "transp_proxy: #{location.css('transp_proxy').children}"
        #  puts "IPv6: #{location.css('IPv6').children}"
        #  puts "NAT: #{location.css('NAT').children}"
        #  puts "AP_no: #{location.css('AP_no').children}"
        #  puts "wired: #{location.css('wired').children}"
      end
      # puts " "
    end

  end

end

