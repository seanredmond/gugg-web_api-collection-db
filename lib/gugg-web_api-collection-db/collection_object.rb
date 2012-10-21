# Interface to Roles table.
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

module Gugg
  module WebApi
    module Collection
      module Db
        class Acquisition < Sequel::Model(:collection_acquisitions)
          # Temporary dummy class because of circular dependency
        end

        class Constituent < Sequel::Model(:collection_tms_constituents)
          # Temporary dummy class because of circular dependency
        end

        class ConstituentXref < Sequel::Model(:collection_tms_conxrefs)
          # Temporary dummy class because of circular dependency
        end

        class Exhibition < Sequel::Model(:collection_tms_exhibitions)
          # Temporary dummy class because of circular dependency
        end

        class ExhibitionXref < Sequel::Model(:collection_tms_exhobjxrefs)
          # Temporary dummy class because of circular dependency
        end

        class Movement < Sequel::Model(:collection_movements)
          # Temporary dummy class because of circular dependency
        end

        class Site < Sequel::Model(:collection_tms_sites)
          # Temporary dummy class because of circular dependency
        end

        class SortFields < Sequel::Model(:collection_sort_fields)
          # Temporary dummy class because of circular dependency
        end

        class CollectionObject < Sequel::Model(:collection_tms_objects)
          include Linkable
          include Dateable
          extend Collectible

        	set_primary_key :objectid
          one_to_many :conxrefs, :class => ConstituentXref, :key => :id
          one_to_many :objtitles, :class => ObjectTitle, :key => :objectid
        	one_to_one :contexts, :class => ObjectContext, :key => :objectid
          one_to_one :sort_fields, :class => SortFields, :key => :objectid
          many_to_many :acquisitions, :class => Acquisition, 
            :join_table => :collection_acquisitionxrefs, 
            :left_key => :objectid, :right_key => :acquisitionid
          one_to_many :exhibition_xrefs, :class => ExhibitionXref, 
            :key => :objectid
          many_to_many :exhibitions, :class => Exhibition, 
            :join_table => :collection_tms_exhobjxrefs, 
            :left_key => :objectid, :right_key => :exhibitionid
          many_to_many :movements, :class => Movement, 
            :join_table => :collection_objmovementxrefs, :left_key => :id, 
            :right_key => :termid
          many_to_many :sites, :class => Site, 
            :join_table => :collection_objsitexrefs, :left_key => :objectid, 
            :right_key => :siteid

          @@web_url = 'http://www.guggenheim.org/new-york/collections/collection-online/show-full/piece/?&search=&f=Title&object='

          def self.on_view(options = {})
            obj_dset = where(:objectid => 
              SortFields.select(:objectid).where(~ :location => nil))

            @obj_pages = obj_dset.paginate(
              self.page_option_or_default(options), 
              self.per_page_option_or_default(options))
            objects_r = self.paginated_resource(obj_dset, options)
            {
              :objects => objects_r,
              :_links => Linkable::make_links(self, @obj_pages, nil, options)              
            }
          end


        	def copyright
        		contexts.shorttext7
        	end

        	def essay
        		contexts.longtext7
        	end

          def is_collection?
            contexts.flag11 == 1
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

          def location
            sort_fields.location
          end

          def constituents
            conxrefs
          end

          def titles(preferred_language = 1)
            # titletypeid's 7, 15, & 16 are series titles, 17 is sort title
            all_titles = objtitles_dataset.
              where(:displayed => 1).
              where(~:active => 0).
              where(~:titletypeid => [7, 15, 16, 17]). 
              order(:displayorder)

            group = TitleGroup.new

            if all_titles.count == 0
              return group
            end

            # The primary title is the first title in the preferred language
            # (Default: English)
            group.primary = all_titles.filter(:languageid => preferred_language).first
            if group.primary == nil
              # or the first title if none is in the preferred language
              group.primary = all_titles.first
            end

            # Make a list of all titles but the preferred
            group.other = all_titles.filter(~:titleid => group.primary.titleid).all
        
            # {
            #   :primary => primary.as_resource,
            #   :other => other.count > 0 ? other.map {|t| t.as_resource} : nil,
            # }

            group

          end

          def series(preferred_language = 1)
            # Guanaroca & Iyaré (98.5238) is the only object (so far) to have two series
            # titles. They don't look properly coded in TMS. We're going to just 
            # pick the first even though is the second that's displayed on gugg.org
        
            all_series = objtitles_dataset.
              where(:displayed => 1).
              where(~:active => 0).
              where(:titletypeid => [7, 15, 16]).
              order(:displayorder)
          
            # The primary series is the first series in the preferred language
            # (Default: English)
            primary = all_series.filter(:languageid => preferred_language).first
            if primary == nil
              # or the first title if none is in the preferred language
              primary = all_series.first
            end
        
            if primary == nil
              return nil
            else
              return primary
            end
          end

          # There is a many-to-one (or none) association between objects
          # and acquisitions but it is mapped as a many-to-many because the 
          # association has to be made in the database through an intermediate
          # table. In this method we are reducing the many-to-many array to
          # a single value or nil.
          def acquisition
            return acquisitions.count > 0 ? acquisitions[0] : nil
          end

        	def as_resource
            links = self_link

            if is_collection?
              links[:web] = {
                :href => @@web_url + objectnumber
              }
            end
            
        		resource = {
              :id => pk,
        			:accession => objectnumber,
        			:sort_number => sortnumber,
              :sort_title => sort_title,
              :sort_name => sort_name,
              :constituents => constituents.map {|c| c.as_resource({'no_objects' => true})},
              :titles => titles.as_resource,
              :series => series == nil ? nil : series.as_resource,
        			:dates => date_resource(datebegin, dateend, dated),
              :sites => sites.count > 0 ? sites.map {
                |s| s.as_resource({'no_objects' => true})} : nil,
              :movements => movements.count > 0 ? movements.map {
                |m| m.as_resource({'no_objects' => true})} : nil,
              :acquisition => acquisition != nil ? 
                acquisition.as_resource({'no_objects' => true}) : nil,
              :exhibitions => exhibitions.count > 0 ? exhibitions.map {
                |e| e.as_resource({'no_objects' => true})} : nil,
        			:edition => edition,
        			:medium => medium,
        			:dimensions => dimensions,
        			:credit => creditline,
        			:highlight => is_highlight?,
        			:recent_acquisition => is_recent_acquisition?,
        			:essay => essay,
              :copyright => copyright,
              :location => location,
              :_links => links
        		}
        	end
        end
      end
    end
  end
end
