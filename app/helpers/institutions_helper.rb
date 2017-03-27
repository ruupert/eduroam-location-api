module InstitutionsHelper
  def import_data import_file

    puts "

    ok lets do this...


"


     doc = Nokogiri::XML(import_file) do |config|
      config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NOBLANKS
     end





    institutions = doc.xpath('//institution')
    institutions.each do |institution|
      puts "country: #{institution.css('country').children}"
      puts "type: #{institution.css('type').children}"
      puts "realm: #{institution.css('inst_realm').children}"
      address = institution.css('institution address')
      puts "street: #{address.css('street').children}"
      puts "city: #{address.css('city').children}"
      contact = institution.css('institution contact')
      puts "c name: #{contact.css('name').children}"
      puts "c email: #{contact.css('email').children}"
      puts "c phone: #{contact.css('phone').children}"
      orgnames = institution.css('org_name')
      orgnames.each do |org|
        puts "org name: #{org.child}"
        org.each { |attr_name, attr_value|
          puts "#{attr_name} -> #{attr_value}"
        }
      end
      info_url = institution.css('institution info_URL')
      info_url.each do |info|
        puts "info url: #{info.child}"
        info.each { |attr_name,attr_value|
          puts "#{attr_name} -> #{attr_value}"
        }
      end
      policy_url = institution.css('institution policy_URL')
      policy_url.each do |policy|
        puts "policy url: #{policy.child}"
        info.each { |attr_name,attr_value|
          puts "#{attr_name} -> #{attr_value}"
        }
      end
      puts "ts: #{institution.css('institution ts').children}"

      locations = institution.css('location')
      locations.each do |location|
        puts "longitude: #{location.css('longitude').children}"
        puts "latitude: #{location.css('latitude').children}"
        location.css('loc_name').each do |loc_name|
          puts "loc_name #{loc_name.child}"
          loc_name.each { |attr_name, attr_value|
            puts "#{attr_name} -> #{attr_value}"
          }
        end
        location.css('address').each do |address|
          puts "street: #{address.css('street').children}"
          puts "city: #{address.css('city').children}"
        end
        puts "SSID: #{location.css('SSID').children}"
        puts "enc_level: #{location.css('enc_level').children}"
        puts "port_restrict: #{location.css('port_restrict').children}"
        puts "transp_proxy: #{location.css('transp_proxy').children}"
        puts "IPv6: #{location.css('IPv6').children}"
        puts "NAT: #{location.css('NAT').children}"
        puts "AP_no: #{location.css('AP_no').children}"
        puts "wired: #{location.css('wired').children}"
      end
      puts " "
    end

        #institutions = doc.xpath('//institution')
    #institutions.each do |institution|
    # orgnames = institution.css('org_name')
    #"#{ orgnames.each do |org|
    #"#{  puts org.child
    #  org.each { |attr_name, attr_value|
    #   puts attr_name
    #   puts attr_value
    # }
    # end
    #end

    # Process each line.

    # For any errors just raise an error with a message like this:
    #   raise "There is a duplicate in row #{index + 1}."
    # And your controller will redirect the user and show a flash message.

  end

end
