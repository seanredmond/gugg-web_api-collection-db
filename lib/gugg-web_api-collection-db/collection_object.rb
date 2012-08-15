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
          one_to_many :objtitles, 
            :class => ObjectTitle, 
            :key => :objectid
        	one_to_one :contexts, 
        		:class => Gugg::WebApi::Collection::Db::ObjectContext,
        		:key => :objectid
          one_to_one :sort_fields, 
            :class => Gugg::WebApi::Collection::Db::SortFields, 
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

          def sort_title
            sort_fields.title
          end

          def sort_name
            sort_fields.constituent
          end

          def titles(preferred_language = 1)
            all_titles = objtitles_dataset.
              where(:displayed => 1).
              where(~:active => 0).
              where(~:titletypeid => [7, 15, 16, 17]).
              order(:displayorder)

            if all_titles.count == 0
              {}
            end

            # The primary title is the first title in the preferred language
            # (Default: English)
            primary = all_titles.filter(:languageid => preferred_language).first
            if primary == nil
              # or the first title if none is in the preferred language
              primary = all_titles.first
            end

            # Make a list of all titles but the preferred
            other = all_titles.filter(~:titleid => primary.titleid)
        
            sort_title = objtitles_dataset(:titletypeid => 17).first
            {
              'primary' => primary.as_resource,
              'other' => other.count > 0 ? other.map {|t| t.as_resource} : nil,
              'sort' => sort_title == nil ? primary.title : sort_title.title
            }

          end

        	def as_resource
        		resource = {
        			:id => pk,
        			:accession => objectnumber,
        			:sort_number => sortnumber,
              :sort_title => sort_title,
              :sort_name => sort_name,
              :titles => titles,
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
