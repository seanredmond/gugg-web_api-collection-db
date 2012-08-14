# Interface to Roles table.
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

module Gugg
  module WebApi
    module Collection
      module Db
        class CollectionObject < Sequel::Model(:collection_tms_objects)
        	set_primary_key :objectid
        	one_to_one :contexts, 
        		:class => Gugg::WebApi::Collection::Db::ObjectContext,
        		:key => :objectid

        	def copyright
        		contexts.shorttext7
        	end

        	def essay
        		contexts.longtext7
        	end

        	def has_essay?
        		contexts.longtext7 != nil
        	end

        	def is_highlight?
        		contexts.flag6 == 1
        	end

        	def is_recent_acquisition?
        		contexts.flag5 == 1
        	end

        	def as_resource
        		resource = {
        			:id => pk,
        			:accession => objectnumber,
        			:sortnumber => sortnumber,
        			:dates => {
        				:begin => datebegin,
        				:end => dateend,
        				:display => dated
        			},
        			:edition => edition,
        			:medium => medium,
        			:dimensions => dimensions,
        			:credit => creditline,
        			:highlight => is_highlight?,
        			:recent_acquisition => is_recent_acquisition?,
        			:has_essay => has_essay?
        		}
        	end
        end
      end
    end
  end
end
