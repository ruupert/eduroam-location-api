require 'csv'
class ExporterController < ApplicationController


  before_action :authenticate


  def add_institution_for(xml, var)

    xml.country var["country"]
    xml.type var["institution_type"]
    tmp_realm = CSV.parse_line(var["inst_realm"])
    if tmp_realm.count > 1
      for i in 0..tmp_realm.count-1
        xml.inst_realm tmp_realm[i]

      end
    else
      xml.inst_realm var['inst_realm']
    end


    Orgname.where(institution_id: var["id"]).each do |org|
      ## lol back in a jiffy...
      xml.org_name(:lang => org["lang"], :class => nil) < org["name"]
    end
    xml.address {
      xml.street var["address"]
      xml.city var["city"]
    }
    if !var["contact_name"].nil?
      tmp_n = CSV.parse_line(var["contact_name"])
      tmp_e = CSV.parse_line(var["contact_email"])
      tmp_p = CSV.parse_line(var["contact_phone"])

      for i in 0..tmp_n.count-1
        xml.contact {
          xml.name tmp_n[i]
          xml.email tmp_e[i]
          xml.phone tmp_p[i]
        }
      end
    else
      xml.contact {
        xml.name var["contact_name"]
        xml.email var["contact_email"]
        xml.phone var["contact_phone"]
      }
    end
    Orginfo.where(institution_id: var["id"]).each do |o|
      xml.info_URL(:lang => o["lang"], :class => nil) < o["url"]

    end
    Orgpolicy.where(institution_id: var["id"]).each do |o|
      xml.policy_URL(:lang => o["lang"], :class => nil) > o["url"]


    end
    #xml.ts var["updated_at"]
    xml.ts Time.parse(var["updated_at"].to_s).strftime("%Y-%m-%dT%H:%M:%S")
    #<ts>2015-01-23T14:00:00.0Z</ts>

    # No idea how one would ask ActiveRecord to do this. Spent like 2-3 hours trying in Rails console, but still no better clue.
    # Took about 10 minutes to write this and may not work on all SQL databases.
    eobj = Entry.find_by_sql ["select entries.id, institution_id, location_id, ap_count, orgssid_id from (select max(id) as id from entries where institution_id = :id group by location_id) as link, entries where link.id=entries.id and ap_count > 0", {:id => var["id"]}]
    add_locations_for(xml,eobj)
  end

  def add_locations_for(xml, entry)
    entry.each do |e|
      if e["ap_count"] > 0

      xml.location {
        loc = Location.where(:id => e["location_id"])
        xml.longitude loc.first.longitude
        xml.latitude loc.first.latitude
        LocName.where(:location_id => e["location_id"]).each do |lname|
          xml.loc_name(:lang => lname["lang"], :class => nil) < lname["name"]
        end
        xml.address {
          identifier_str = ""
          if loc.first.identifier != "0"
            identifier_str = loc.first.identifier
          end
          xml.street "#{loc.first.address} #{identifier_str}".chomp(" ")
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
        xml.info_URL(:lang => "en", :class => nil) < orgssid.institution.primary_info_url
      }
      end

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
    doc = Nokogiri::XML(File.read("lib/assets/xml_out.xml")) do |config|
      config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NOBLANKS
    end
    doc.xpath('//@class').remove

    if xsd.valid?(doc)

      render(xml: doc)
    else

      render(xml: xsd.errors)
    end


  end

end
