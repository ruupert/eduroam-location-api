require 'csv'
module InstitutionsHelper

  def value_bool(input)
    if input == "true"
      return true
    else
      return false
    end
  end

  def import_data_old import_file
    # This method handles eduroam any xml-file that complies with the institution.xsd schema and
    # is by no means perfect or the best way to do things but given that the xml-data needs to be split
    # into multiple tables I saw no other reasonably fast way to walk and insert data to this applications
    # database structure. This would also get a rewrite or another in the future if/when the .xsd schema
    # changes.
    #
    # This method is intended to be run just once and only for the admin.
    # This method should not mind if there were multiple imports
    # containing duplicates. Not yet there.
    #
    # Basic gist of the method:
    # 1. validate the uploaded file
    # 2. unless valid, do nothing
    # 3. otherwise process the file and insert into institutions, locations, loc_names, orgnames, orgssids
    #    and entries
    # 4. Yet not quite working: after insertions, check for orgssids that are indentical and change entries
    #    to point to one of the distinct ssids and then remove all orphaned ssids.


    doc = Nokogiri::XML(import_file) do |config|
      config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NOBLANKS
    end
    xsd = Nokogiri::XML::Schema(File.read("lib/assets/institution.xsd"))
    if xsd.valid?(doc)
      q = Queue.new
      o = OpenStruct.new(Hash.from_xml(import_file))

      # OpenStruct doesn't map attributes, so given that the lang-attributes
      # are found in the document in same order, they can be queued and then dequeued appropriately
      doc.search("[lang]").each do |s|
        q.push(s['lang'])
      end
      Array.wrap(o['institutions']['institution']).each do |x|
        pp x.inspect
        n = Institution.new
        n.country = x['country']

        if Array(x['inst_realm']).count > 1
          csv_string = CSV.generate do |csv|
            csv << x['inst_realm']

          end
        else
          csv_string = x['inst_realm']
        end

        n.inst_realm = csv_string


        tmp_p = ""
        tmp_n = ""
        tmp_e = ""

        if Array.wrap(x['contact']).count > 1
          x['contact'].each do |xc|
            tmp_n += "#{xc['name']}, "
            tmp_p += "#{xc['phone']}, "
            tmp_e += "#{xc['email']}, "
          end
          n.contact_name = tmp_n.chomp(", ")
          n.contact_email = tmp_e.chomp(", ")
          n.contact_phone = tmp_p.chomp(", ")

        else
          n.contact_name = x['contact']['name']
          n.contact_email = x['contact']['email']
          n.contact_phone = x['contact']['phone']

        end


        n.institution_type = x['type'].to_i
        n.address = x['address']['street']
        n.city = x['address']['city']
        Array.wrap(x['org_name']).each do |org|
          n.orgnames.build
          n.orgnames.last.name = org || " "
          n.orgnames.last.lang = q.pop
        end

        Array.wrap(x['policy_URL']).each do |org|
          n.orgpolicies.build
          if org.to_s.include?('{"lang"=>"')
            n.orgpolicies.last.url = ""
          else
            n.orgpolicies.last.url = org

          end

          n.orgpolicies.last.lang = q.pop
        end

        Array.wrap(x['info_URL']).each do |org|
          n.orginfos.build
          if org.to_s.include?('{"lang"=>"')
            n.orginfos.last.url = ""
          else

            n.orginfos.last.url = org
          end

          n.orginfos.last.lang = q.pop


        end
        Array.wrap(x['location']).first do |ssid| # Purkkaa
          n.orgssids.build
          n.orgssids.first.name = ssid['SSID']


        end
        if !Array.wrap(x['location']).nil?

          Array.wrap(x['location']).each do |item|

            n.locations.build
            tmp_str = item['address']['street']
            n.locations.last.orig_import_string = tmp_str
            building_identifier = tmp_str.to_s.match(/[0-9]+(.*)/).to_s.match(/[A-z]/).to_s.upcase
            tmp_str = item['address']['street']

            clean_address = tmp_str.to_s.match(/[A-zÄÖÅäöå ]+[0-9]+/).to_s
            if clean_address == ""
              clean_address = item['address']['street']
            end
#            if building_identifier.nil?
#              building_identifier = "0"
#            end

            n.locations.last.address = clean_address
            n.locations.last.identifier= building_identifier


            n.locations.last.city = item['address']['city']
            n.locations.last.country = item['address']['country']
            n.locations.last.longitude = item['longitude']
            n.locations.last.latitude = item['latitude']
            Array.wrap(item['loc_name']).each do |lname|
              n.locations.last.loc_names.build
              n.locations.last.loc_names.last.name = lname
              n.locations.last.loc_names.last.lang = q.pop
            end

            enc_str = item['enc_level'].to_s
            if enc_str.include? "WPA2/AES"
              tmp_wpa2_aes = true
            else
              tmp_wpa2_aes = false
            end
            if enc_str.include? "WPA2/TKIP"
              tmp_wpa2_tkip = true
            else
              tmp_wpa2_tkip = false
            end
            if enc_str.include? "WPA/TKIP"
              tmp_wpa_tkip = true
            else
              tmp_wpa_tkip = false
            end
            if enc_str.include? "WPA/AES"
              tmp_wpa_aes = true
            else
              tmp_wpa_aes = false
            end


            res = Orgssid.where(institution_id: n.id,
                                name: item['SSID'],
                                port_restrict: item['port_restrict'],
                                transp_proxy: item['transp_proxy'],
                                ipv6: item['IPv6'],
                                nat: item['NAT'],
                                wpa_tkip: tmp_wpa_tkip,
                                wpa_aes: tmp_wpa_aes,
                                wpa2_tkip: tmp_wpa2_tkip,
                                wpa2_aes: tmp_wpa2_aes,
                                wired: item['wired'])
            if res.count == 1
              entry_ssid_id = res.first.id
            else
              n.orgssids.build
              n.orgssids.last.name = item['SSID']
              n.orgssids.last.port_restrict = value_bool(item['port_restrict'])
              n.orgssids.last.ipv6 = value_bool(item['IPv6'])
              n.orgssids.last.nat = value_bool(item['NAT'])
              n.orgssids.last.transp_proxy = value_bool(item['transp_proxy'])
              n.orgssids.last.wired = value_bool(item['wired'])
              n.orgssids.last.wpa2_aes = tmp_wpa2_aes
              n.orgssids.last.wpa2_tkip = tmp_wpa2_tkip
              n.orgssids.last.wpa_tkip = tmp_wpa_tkip
              n.orgssids.last.wpa_aes = tmp_wpa_aes
              entry_ssid_id = n.orgssids.last.id
              n.save

            end


            n.entries.build
            n.entries.last.location_id = n.locations.last.id
            n.entries.last.orgssid_id = entry_ssid_id
            n.entries.last.institution_id = n.id

            n.entries.last.ap_count = item['AP_no']
            n.save

          end

        end

      end
    end

  end


  def import_data import_file
#    import_file = File.read("../institution.xml")

    doc = Nokogiri::XML(import_file) do |config|
      config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NOBLANKS
    end
    xsd = Nokogiri::XML::Schema(File.read("lib/assets/institution.xsd"))
    if xsd.valid?(doc)
      q = Queue.new
      o = OpenStruct.new(Hash.from_xml(import_file))

      # OpenStruct doesn't map attributes, so given that the lang-attributes
      # are found in the document in same order, they can be queued and then dequeued appropriately
      doc.search("[lang]").each do |s|
        q.push(s['lang'])
      end
      Array.wrap(o['institutions']['institution']).each do |x|
        pp x.inspect
        n = Institution.new
        n.country = x['country']

        if Array(x['inst_realm']).count > 1
          csv_string = CSV.generate do |csv|
            csv << x['inst_realm']

          end
        else
          csv_string = x['inst_realm']
        end

        n.inst_realm = csv_string


        tmp_p = ""
        tmp_n = ""
        tmp_e = ""

        if Array.wrap(x['contact']).count > 1
          x['contact'].each do |xc|
            tmp_n += "#{xc['name']}, "
            tmp_p += "#{xc['phone']}, "
            tmp_e += "#{xc['email']}, "
          end
          n.contact_name = tmp_n.chomp(", ")
          n.contact_email = tmp_e.chomp(", ")
          n.contact_phone = tmp_p.chomp(", ")

        else
          n.contact_name = x['contact']['name']
          n.contact_email = x['contact']['email']
          n.contact_phone = x['contact']['phone']

        end


        n.institution_type = x['type'].to_i
        n.address = x['address']['street']
        n.city = x['address']['city']
        Array.wrap(x['org_name']).each do |org|
          n.orgnames.build
          n.orgnames.last.name = org || " "
          n.orgnames.last.lang = q.pop
        end

        Array.wrap(x['policy_URL']).each do |org|
          n.orgpolicies.build
          if org.to_s.include?('{"lang"=>"')
            n.orgpolicies.last.url = ""
          else
            n.orgpolicies.last.url = org

          end

          n.orgpolicies.last.lang = q.pop
        end

        Array.wrap(x['info_URL']).each do |org|
          n.orginfos.build
          if org.to_s.include?('{"lang"=>"')
            n.orginfos.last.url = ""
          else

            n.orginfos.last.url = org
          end

          n.orginfos.last.lang = q.pop


        end
        n.save

        cur_institution_id = n.id


        if !Array.wrap(x['location']).nil?

          Array.wrap(x['location']).each do |item|
            loc = Location.new

            tmp_str = item['address']['street']
            loc.orig_import_string = tmp_str
            building_identifier = tmp_str.to_s.match(/[0-9]+(.*)/).to_s.match(/[A-z]/).to_s.upcase
            tmp_str = item['address']['street']

            clean_address = tmp_str.to_s.match(/[A-zÄÖÅäöå ]+[0-9]+/).to_s
            if clean_address == ""
              clean_address = item['address']['street']
            end

            loc.address = clean_address
            loc.identifier= building_identifier


            loc.city = item['address']['city']
            loc.country = item['address']['country']
            loc.longitude = item['longitude']
            loc.latitude = item['latitude']
            loc.institution_id = cur_institution_id
            loc.save

            while loc.save == false
              loc.identifier += "."
              loc.save
            end
            cur_location_id = loc.id
            Array.wrap(item['loc_name']).each do |lname|
              loc_name = LocName.new
              loc_name.location_id = cur_location_id
              loc_name.name = lname
              loc_name.lang = q.pop
              loc_name.save
            end

            enc_str = item['enc_level'].to_s
            if enc_str.include? "WPA2/AES"
              tmp_wpa2_aes = true
            else
              tmp_wpa2_aes = false
            end
            if enc_str.include? "WPA2/TKIP"
              tmp_wpa2_tkip = true
            else
              tmp_wpa2_tkip = false
            end
            if enc_str.include? "WPA/TKIP"
              tmp_wpa_tkip = true
            else
              tmp_wpa_tkip = false
            end
            if enc_str.include? "WPA/AES"
              tmp_wpa_aes = true
            else
              tmp_wpa_aes = false
            end


            res = Orgssid.where(institution_id: n.id,
                                name: item['SSID'],
                                port_restrict: item['port_restrict'],
                                transp_proxy: item['transp_proxy'],
                                ipv6: item['IPv6'],
                                nat: item['NAT'],
                                wpa_tkip: tmp_wpa_tkip,
                                wpa_aes: tmp_wpa_aes,
                                wpa2_tkip: tmp_wpa2_tkip,
                                wpa2_aes: tmp_wpa2_aes,
                                wired: item['wired'])
            if res.count == 1
              cur_ssid_id = res.first.id
            else
              orgssid = Orgssid.new
              orgssid.name = item['SSID']
              orgssid.port_restrict = value_bool(item['port_restrict'])
              orgssid.ipv6 = value_bool(item['IPv6'])
              orgssid.nat = value_bool(item['NAT'])
              orgssid.transp_proxy = value_bool(item['transp_proxy'])
              orgssid.wired = value_bool(item['wired'])
              orgssid.wpa2_aes = tmp_wpa2_aes
              orgssid.wpa2_tkip = tmp_wpa2_tkip
              orgssid.wpa_tkip = tmp_wpa_tkip
              orgssid.wpa_aes = tmp_wpa_aes
              orgssid.institution_id = cur_institution_id
              orgssid.save
              cur_ssid_id = orgssid.id
            end
            if !cur_location_id.nil?

              entry = Entry.new
              entry.location_id = cur_location_id
              entry.orgssid_id = cur_ssid_id
              entry.institution_id = cur_institution_id
              entry.ap_count = item['AP_no']
              entry.save
            end

          end

        end

      end
    end

  end


end

