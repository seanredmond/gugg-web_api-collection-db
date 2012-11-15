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

        # An interface to collection_tms_objects and related tables
        class CollectionObject < Sequel::Model(:collection_tms_objects)
          include Linkable
          include Dateable
          extend Collectible

          set_primary_key :objectid
          one_to_many :conxrefs, :class => ConstituentXref, :key => :id
          one_to_many :objtitles, :class => ObjectTitle, :key => :objectid
          one_to_many :media, :class => Media, :key => :objectid
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

          # Returns a paginated list of objects on view
          #
          # @param [Hash] options A hash of options to be passed to 
          #   {#as_resource}
          # @return [Hash] A resource containing a list of objects on view
          #
          # An object is considered to be "on view" if it has a location in a 
          # currently open exhibition
          def self.on_view(options = {})
            (dataset_pages, dateset_resource) = paginated_resource(
              where(:objectid => SortFields.select(:objectid).
                where(~ :location => nil)), 
              options)

            {
              :objects => dateset_resource,
              :_links => Linkable::make_links(self, dataset_pages, nil, options)              
            }
          end

          # Returns a list of years in which objects where created with counts
          # of objects created in each year
          #
          # @param [Hash] options A hash of options to be passed to 
          #   {#as_resource}
          # @return [Hash] A resource containing a list of years and counts
          #
          # This method only counts objects that are owned by SRGM (currently
          # indicated by having a departmentid other than 7)
          def self.years(options = {})
            # "not departmentid = 7" clause should objects to those owned by 
            # SRGM
            years = group_and_count(:datebegin.as(:year)).
              where(~:departmentid=>7)

            years = years.all.map{|y| 
              {
                :year => y[:year],
                :name => "#{y[:year]}",
                :objects => {
                  :total_count => y[:count] 
                },
                :_links => Linkable::make_links(self, nil, nil, 
                  {:add_to_path => [options[:add_to_path], y[:year]].join('/')})              
              }
            }

            return {
              :dates => years,
              :_links => Linkable::make_links(self, nil, nil, options)
            }
          end

          # Returns a list of decades in which objects where created
          #
          # @param [Hash] options A hash of options to be passed to 
          #   {#as_resource}
          # @return [Hash] A resource containing a list of decades
          #
          # This method only counts objects that are owned by SRGM (currently
          # indicated by having a departmentid other than 7)
          def self.decades(options = {})
            years = select(:datebegin.as(:year)).
              union(select(:dateend.as(:year))).
              distinct.filter(~:year => nil).
              filter(~:year => 0).order(:year).all.
              map{|y| (y[:year]/10) * 10}.uniq

            links = Linkable::make_links(self, nil, nil, options)

            decades = []
            years = years.each do |y| 
              decade_link = Linkable::make_links(self, nil, nil, 
                {:add_to_path => [options[:add_to_path], y, y+9].join('/')})
              decades += [decade_link[:_self].merge({:title => "#{y}s"})]
            end

            return {:_links => links.merge({:decades => decades})}
          end

          # Returns a list of objects created in the given year. Every object
          # is dated with a date range (start, end) and for many objects 
          # start = end. An object is considered to have been created in a 
          # given year (y) if start <= y <= end
          #
          # @param [integer] year The year to search
          # @param [Hash] options A hash of options to be passed to 
          #   {#as_resource}
          # @return [Hash] A resource containing a list of decades
          #
          # This method only counts objects that are owned by SRGM (currently
          # indicated by having a departmentid other than 7)
          def self.by_year(year, options = {})
            begin
              year = Integer(year)
              (dataset_pages, dateset_resource) = 
                paginated_resource(where(:datebegin <= year, :dateend >= year, 
                    ~:departmentid=>7),
                options)

              {
                :objects => dateset_resource,
                :_links => Linkable::make_links(self, dataset_pages, nil, 
                  {:add_to_path => [options[:add_to_path], year].join('/')})              
              }
            rescue ArgumentError => e
              raise Db::BadParameterError, e.message
            end
          end

          # Returns a list of objects created between the two given years, 
          # inclusive. Every object is dated with a date range (start, end) 
          # and for many objects start = end. An object is considered to have 
          # been created in a given range of years (y1, y2) if:
          #
          #     y1 <= start <= y2 ∨ y1 <= end <= y2
          #
          # @param [integer] start_year The beginning year of the range
          # @param [integer] end_year The end year of the range
          # @param [Hash] options A hash of options to be passed to 
          #   {#as_resource}
          # @return [Hash] A resource containing a list of decades
          #
          # This method only counts objects that are owned by SRGM (currently
          # indicated by having a departmentid other than 7)
          def self.by_year_range(start_year, end_year, options = {})
            begin
              start_year = Integer(start_year)
              end_year = Integer(end_year)

              if (end_year < start_year)
                raise Db::BadParameterError, 
                  "Start year of range must be less than end year"
              end

              (dataset_pages, dateset_resource) = 
                paginated_resource(
                  where{
                    ((:datebegin >= start_year) & (:datebegin <= end_year)) | 
                    ((:dateend >= start_year) & (:dateend <= end_year))}.
                  where(~:departmentid=>7),
                options)

              {
                :objects => dateset_resource,
                :_links => Linkable::make_links(self, dataset_pages, nil, 
                  {:add_to_path => 
                    [options[:add_to_path], start_year, end_year].join('/')})              
              }
            rescue ArgumentError => e
              raise Db::BadParameterError, e.message
            end
          end

          # Get the copyright statement
          #
          # @return [String] The copyright
          def copyright
            contexts.shorttext7
          end

          # Get the object essay
          #
          # @return [String] The essay
          def essay
            contexts.longtext7
          end

          # Is this part of the Collection Online?
          #
          # @return [Boolean] The answer.
          def is_collection?
            contexts.flag11 == 1
          end

          # Can this be a daily highlight?
          #
          # @return [Boolean] The answer.
          def is_highlight?
            contexts.flag6 == 1
          end

          # Is this a recent acquisition?
          #
          # @return [Boolean] The answer
          def is_recent_acquisition?
            contexts.flag5 == 1
          end

          # Get the sortable version of the primary title
          #
          # @return [String]
          def sort_title
            sort_fields.title
          end

          # Get the sortable version of the artist's name
          #
          # @return [String]
          def sort_name
            sort_fields.constituent
          end

          # Get the object's current location
          #
          # @return [String]
          def location
            sort_fields.objlocation
          end

          # Get the object's constituents
          #
          # @return [Array<ConstituentXref>] An array of the {ConstituentXref}
          #   objects linked to the CollectionObject 
          def constituents
            conxrefs
          end

          # Get the object's titles
          #
          # @param [Integer] A language code used to calculate the primary 
          #   title
          #
          # @return [TitleGroup]
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

          # Get the object's series
          #
          # @param [Integer] A language code used to calculate the primary 
          #   title for the series
          #
          # @return [ObjectTitle]
          def series(preferred_language = 1)
            # Guanaroca & Iyaré (98.5238) is the only object (so far) to have 
            # two series titles. They don't look properly coded in TMS. We're 
            # going to just pick the first even though is the second that's 
            # displayed on gugg.org
        
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

          # Get the acquisition to which the object belongs
          #
          # @return [Acquisition]
          #
          # There is a many-to-one (or none) association between objects
          # and acquisitions but it is mapped as a many-to-many because the 
          # association has to be made in the database through an intermediate
          # table. In this method we are reducing the many-to-many array to
          # a single value or nil.
          def acquisition
            return acquisitions.count > 0 ? acquisitions[0] : nil
          end

          # Returns a representation of the object in a hash suitable for
          # output as a JSON resource
          #
          # @return [Hash] The resource
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
              :location => location == nil ? nil : location.as_resource,
              :media => media.count > 0 ? media.map { |m|
                m.as_resource
              } : nil,
              :_links => links
            }
          end
        end
      end
    end
  end
end
