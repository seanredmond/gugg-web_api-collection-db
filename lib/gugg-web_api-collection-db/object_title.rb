# Interface to Object Titles table.
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

module Gugg
  module WebApi
    module Collection
      module Db
        class ObjectTitle < Sequel::Model(:collection_tms_objtitles)
	        many_to_one :titletypes, :class => TitleType, :key => :titletypeid
        	many_to_one :languages, :class => Language, :key => :languageid
	        def as_resource(extended = false)
	          # Titles might have NULL, 0 (not assigned), or 7 (multiple) as the language.
	          # Return nil for all of these

	          resource = {
	            :language => [nil, 0, 7].include?(languageid) ? nil : languages.codes.language_code,
	            :type => titletypes.titletype,
	            :order => displayorder
	          }
	    
	          if [7, 15, 16].include?(titletypeid)
	            phrase = collection_tms_titletypes.titletype.match(/\((.+)\)/)
	            if phrase == nil
	              raise UnknownSeriesFormatError, "Cannot parse series title format \"#{collection_tms_titletypes.titletype}\""
	            end
	      
	            resource['title'] = title
	            resource['phrasing'] = phrase[1].sub("X", "#{title}")
	            resource['html'] = phrase[1].sub("X", "<i>#{title}</i>")
	          else
	            resource['title'] = title
	          end
	    
	          if extended == true
	            resource['object'] = Objects[objectid].as_resource
	          end
	    
	    
	          resource
	        end

        end
      end
    end
  end
end
