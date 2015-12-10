#Apply this monkey patch in your application.rb 
#See: https://github.com/andre/geokit-gem/issues#issue/7
module Geokit
  require 'uri'
  module Geocoders
    class Geocoder
      def self.logger() 
        if Geokit::Geocoders::logger.nil?
          Geokit::Geocoders::logger = Logger.new(STDOUT)
          Geokit::Geocoders::logger.level=Logger::DEBUG
        end
        Geokit::Geocoders::logger
      end
    end
    class GoogleGeocoder < Geocoder
      
      private
      
      def self.do_geocode(address, options = {})
        bias_str = options[:bias] ? construct_bias_string_from_options(options[:bias]) : ''
        address_str = address.is_a?(GeoLoc) ? address.to_geocodeable_s : address
        #res = self.call_geocoder_service("http://maps.google.com/maps/geo?q=#{Geokit::Inflector::url_escape(address_str)}&output=xml#{bias_str}&key=#{Geokit::Geocoders::google}&oe=utf-8")
        res = self.call_geocoder_service("http://maps.google.com/maps/geo?q=#{URI.escape(address_str)}&output=xml#{bias_str}&key=#{Geokit::Geocoders::google}&oe=utf-8")
        return GeoLoc.new if !res.is_a?(Net::HTTPSuccess)
        xml = res.body
        xml.force_encoding(Encoding::UTF_8) if xml.respond_to?(:force_encoding)
        #pablocantero logger.debug "Google geocoding. Address: #{address}. Result: #{xml}"
        return self.xml2GeoLoc(xml, address)        
      end
      
      def self.xml2GeoLoc(xml, address="")
        doc=REXML::Document.new(xml)

        if doc.elements['//kml/Response/Status/code'].text == '200'
          geoloc = nil
          # Google can return multiple results as //Placemark elements. 
          # iterate through each and extract each placemark as a geoloc
          doc.each_element('//Placemark') do |e|
            extracted_geoloc = extract_placemark(e) # g is now an instance of GeoLoc
            if geoloc.nil? 
              # first time through, geoloc is still nil, so we make it the geoloc we just extracted
              geoloc = extracted_geoloc 
            else
              # second (and subsequent) iterations, we push additional 
              # geolocs onto "geoloc.all" 
              geoloc.all.push(extracted_geoloc) 
            end  
          end
          return geoloc
        elsif doc.elements['//kml/Response/Status/code'].text == '620'
           raise Geokit::TooManyQueriesError
        else
          logger.info "Google was unable to geocode address: "+address
          return GeoLoc.new
        end

      rescue Geokit::TooManyQueriesError
        # re-raise because of other rescue
        raise Geokit::TooManyQueriesError, "Google returned a 620 status, too many queries. The given key has gone over the requests limit in the 24 hour period or has submitted too many requests in too short a period of time. If you're sending multiple requests in parallel or in a tight loop, use a timer or pause in your code to make sure you don't send the requests too quickly."
      rescue
        #pabllogger.error "Caught an error during Google geocoding call: "+$!
        return GeoLoc.new
      end
      
    end
  end
end