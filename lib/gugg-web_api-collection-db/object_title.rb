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
	          # Titles might have NULL, 0 (not assigned), or 7 (multiple) as 
	          # the language. Return nil for all of these
	          resource = {
	          	:title => title,
	            :language => [nil, 0, 7].include?(languageid) ? nil : 
	            	languages.codes.language_code,
	            :type => titletypes.titletype,
	            :order => displayorder,
	            :prepend => nil,
	            :append => nil
	          }

						# These titletypes are use to indicate the phrasing of a series 
						# title
						#
						#   7  = from the series X
						#   15 = from the X series	
						#   16 = from X
						#
						# We'll break that up into a phrase to prepend and/or append to the 
						# title when it is displayed
	          if [7, 15, 16].include?(titletypeid)
	          	resource[:type] = "Series"
	            phrase = titletypes.titletype.match(/\((.+)\)/)
	            if phrase == nil
	              raise UnknownSeriesFormatError, "Cannot parse series title format \"#{collection_tms_titletypes.titletype}\""
	            end

	            affixes = phrase[1].match(/^(.+)?(X)(.+)?$/)
	            if affixes[1] != nil
	            	resource[:prepend] = affixes[1].strip
	            end

	            if affixes[3] != nil
	            	resource[:append] = affixes[3].strip
	            end
	          end
	    
	          if extended == true
	            resource['object'] = Objects[objectid].as_resource
	          end

	          resource
	        end

        end

        class TitleGroup
        	attr_accessor :primary, :other

        	def initialize
        		@primary = nil
        		@other = []
        	end

        	def as_resource
        		{
        			:primary => @primary.as_resource,
        			:other => @other.count > 0 ? @other.map {|t| t.as_resource} : nil
        		}
        	end
        end
      end
    end
  end
end
