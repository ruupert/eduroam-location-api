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
      xml.policy_URL(:lang => o["lang"], :class => nil) < o["url"]

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
        xml.SSID "joo"
        xml.enc_level "jees"
        xml.port_restrict "alkaa"
        xml.transp_proxy "luonnistumaan"
        xml.IPv6 "pikku"
        xml.NAT "hiljaa"
        xml.AP_no e["apcount"]
        xml.wired "juuei"
        xml.info_URL "jeh"
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

      render(xml: xml)

    end
  end

end
