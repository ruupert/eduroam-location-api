class ExporterController < ApplicationController
  before_action :authenticate


  def add_institution_for(xml, var)

    xml.country var["country"]
    xml.type var["institution_type"]
    xml.inst_realm var["inst_realm"]

    Orgname.where(institution_id: var["id"]).each do |org|
      ## lol back in a jiffy...
      xml.org_name(:lang => org["lang"], :class => nil) < org["name"]
    end
    xml.address {
      xml.street var["address"]
      xml.city var["city"]
    }
    xml.contact {
      xml.name var["contact_name"]
      xml.email var["contact_email"]
      xml.phone var["contact_phone"]
    }
    Orginfo.where(institution_id: var["id"]).each do |o|
      xml.info_URL(:lang => o["lang"], :class => nil) < o["url"]

    end
    Orgpolicy.where(institution_id: var["id"]).each do |o|
      xml.policy_URL(:lang => o["lang"], :class => nil) > o["url"]


    end
    xml.ts var["updated_at"]

    xml.locations {
      add_locations_for(xml, Entry.where(institution_id: 2).where(ap_count: 1..Float::INFINITY))
    }

  end
  def add_locations_for(xml, entry)
    entry.each do |e|
      xml.location {
        loc = Location.where(:id => e["location_id"])
        xml.longitude loc.first.longitude
        xml.latitude loc.first.latitude
        LocName.where(:location_id => e["location_id"]).each do |lname|
          xml.loc_name(:lang => lname["lang"], :class => nil) < lname["name"]
        end
        xml.address {
          xml.street "#{loc.first.address} #{loc.first.identifier}".chomp(" ")
          xml.city loc.first.city
        }
        orgssid = Orgssid.find(e.orgssid_id)
        xml.SSID orgssid.name
        xml.enc_level orgssid.enc_levels
        xml.port_restrict orgssid.port_restrict
        xml.transp_proxy orgssid.transp_proxy
        xml.IPv6 orgssid.ipv6
        xml.NAT orgssid.nat
        xml.AP_no e["ap_count"]
        xml.wired orgssid.wired
        xml.info_URL orgssid.institution.primary_info_url
      }
    end
  end

  def institutions
    @institutions = Institution.all

    @builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
      xml.institutions {
        @institutions.each do |ins|
          xml.institution {
            add_institution_for(xml, ins)
          }

        end
      }


      file = File.new("lib/assets/xml_out.xml", "wb")
      file.write(xml.to_xml)
      file.close

    end

    xsd = Nokogiri::XML::Schema(File.read("lib/assets/institution.xsd"))
    doc = Nokogiri::XML( File.read("lib/assets/xml_out.xml") ) do |config|
      config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NOBLANKS
    end
    doc.xpath('//@class').remove

    if xsd.valid?(doc)

      render(xml: doc)
    else
      render(xml: doc)

#      render(xml: xsd.errors)
    end





  end

end
