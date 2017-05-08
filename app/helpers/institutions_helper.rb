module InstitutionsHelper

  def import_data import_file
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
          if org.to_s.include?('{"lang"=>"')
            n.orgpolicies.last.url = ""
          else
            n.orgpolicies.last.url = org

          end

          n.orgpolicies.last.lang = q.pop
        end

        x['info_URL'].each do |org|
          n.orginfos.build
          if org.to_s.include?('{"lang"=>"')
            n.orginfos.last.url = ""
          else

            n.orginfos.last.url = org
          end

          n.orginfos.last.lang = q.pop


        end
        x['location'].first do |ssid| # Purkkaa
          n.orgssids.build
          n.orgssids.first.name = ssid['SSID']


        end

        Array.wrap(x['location']).each do |item|

          n.locations.build
          tmp_str = item['address']['street']
          building_identifier = tmp_str.to_s.match(/[0-9]+(.*)/).to_s.match(/[A-z]/).to_s.upcase
          tmp_str = item['address']['street']

          clean_address = tmp_str.to_s.match(/[A-z ]+[0-9]+/).to_s
          if building_identifier.nil?
            building_identifier = "0"
          end

          n.locations.last.address = clean_address
          n.locations.last.identifier= building_identifier


          n.locations.last.city = item['address']['city']
          n.locations.last.country = item['address']['country']
          n.locations.last.longitude = item['longitude']
          n.locations.last.latitude = item['latitude']
          item['loc_name'].each do |lname|
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
              n.save
          else
            n.orgssids.build

            # some defaults probably not needed
            n.orgssids.last.port_restrict = false
            n.orgssids.last.transp_proxy = false
            n.orgssids.last.ipv6 = false
            n.orgssids.last.nat = false
            n.orgssids.last.wpa2_aes = false
            n.orgssids.last.wpa2_tkip = false
            n.orgssids.last.wpa_tkip = false
            n.orgssids.last.wpa_aes = false

            n.orgssids.last.name = item['SSID']
            n.orgssids.last.port_restrict = item['port_restrict']
            n.orgssids.last.ipv6 = item['IPv6']
            n.orgssids.last.nat = item['NAT']
            n.orgssids.last.transp_proxy = item['transp_proxy']
            n.orgssids.last.wired = item['wired']
            enc_str = item['enc_level'].to_s
            if enc_str.include? "WPA2/AES"
              n.orgssids.last.wpa2_aes = tmp_wpa2_aes
            end
            if enc_str.include? "WPA2/TKIP"
              n.orgssids.last.wpa2_tkip = tmp_wpa2_tkip
            end
            if enc_str.include? "WPA/TKIP"
              n.orgssids.last.wpa_tkip = tmp_wpa_tkip
            end
            if enc_str.include? "WPA/AES"
              n.orgssids.last.wpa_aes = tmp_wpa_aes
            end

            n.save
            entry_ssid_id = n.id
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

