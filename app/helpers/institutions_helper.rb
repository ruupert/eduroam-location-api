module InstitutionsHelper

  def import_data

    o = OpenStruct.new(Hash.from_xml(File.read("lib/assets/haagahelia2.xml")))

    o['institutions']['institution'].each do |x|
      q = Queue.new
      n = Institution.new
      n.country = x['country']
      n.inst_realm = x['inst_realm']
      n.contact_name = x['contact']['name']
      n.contact_email = x['contact']['email']
      n.contact_phone = x['contact']['phone']
      n.institution_type = x['type'].to_i
      n.address = x['address']['street']
      n.city = x['address']['city']
      q.push("en")
      q.push("fi")
      x['org_name'].each do |org|
        n.orgnames.build
        n.orgnames.last.name = org || " "
        n.orgnames.last.lang = q.pop
      end
      q.push("en")
      q.push("fi")

      x['policy_URL'].each do |org|
            n.orgpolicies.build
            n.orgpolicies.last.url = org
            n.orgpolicies.last.lang = q.pop
      end
      q.push("en")
      q.push("fi")

      x['info_URL'].each do |org|
        n.orginfos.build
        n.orginfos.last.url = org
        n.orginfos.last.lang = q.pop
      end
      x['location'].each do |item|
        nloc = Location.new
        nloc.address = item['address']['street']
        nloc.city = item['address']['city']
        nloc.longitude = item['longitude']
        nloc.latitude = item['latitude']
        q.push("en")
        q.push("fi")
        nloc['loc_name'].each do |lname|
          nloc.loc_names.build
          nloc.loc_names.name = lname
          nloc.loc_names.lang = q.pop
        end
        nloc.save!
        n.entries.build
        n.entries.location_id = nloc.id
        n.entries.institution_id = n.id
        n.entries.ap_count = item['AP_no']
      end

        #n.save!

    end



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

