# Interface to Constituents table.
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

module Gugg
  module WebApi
    module Collection
      module Db
        class Constituent < Sequel::Model(:collection_tms_constituents)
          set_primary_key :constituentid
          many_to_many :objects, :class=>CollectionObject, 
            :join_table=>:collection_tms_conxrefs, 
            :left_key=>:constituentid, :right_key=>:id
          one_to_many :conxrefs, :class => ConstituentXref, :key => :constituentid
          one_to_one :bio_entry, :class => TextEntry, :key => :id, :conditions=>{:texttypeid=>135}

          include Linkable
          include Collectible

          dataset_module do
            def public_view
              filter(:conxrefs => ConstituentXref.filter(:displayed => 1)).
              order(:alphasort)
            end

            def permanent_collection
              filter(:conxrefs => ConstituentXref.filter(:displayed => 1)).
              filter(:objects => CollectionObject.filter(~:departmentid => 7)).
              order(:alphasort)
            end
          end

          set_dataset(self.public_view)

          def self.list(options = {})
            if options.keys.include?('initial')
              begin
                match = options['initial'].match(/^[a-zA-Z]$/)
                if match != nil
                  selection = filter(:conxrefs => ConstituentXref.
                    filter(:displayed => 1)).
                    filter(:objects => CollectionObject.
                      filter(~:departmentid => 7)).
                    where(:alphasort.ilike("#{match[0]}%")).
                    order(:alphasort).all
                else
                  # Getting here means that a string was passed via the 
                  # "initial" parameter but it wasn't a single letter
                  raise Db::BadParameterError, 
                    "'initial' option must be a single letter, a-z or A-Z, "\
                    "not '#{options['initial']}'" 
                  end
              rescue NoMethodError => e
                # Getting here means that whatever was passed in the "initial"
                # option, couldn't be treated as a string (only strings have
                # a match method)
                raise Db::BadParameterError, 
                  "'initial' option must be a single letter, a-z or A-Z, "\
                  "not '#{options['initial']}'" 
              end
            else
              selection = filter(:conxrefs => ConstituentXref.
                  filter(:displayed => 1)).
                filter(:objects => CollectionObject.
                  filter(~:departmentid => 7)).
                order(:alphasort).all
            end

            {
              :constituents => selection.
                map{|a| a.as_resource({'no_objects' => true}.merge!(options))}
            }
          end

          def bio
            if bio_entry == nil
              nil
            else
              bio_entry.textentry
            end
          end

          # Does this constituent have a bio?
          #
          # @return [Boolean]
          def has_bio?
            bio != nil
          end


          def as_resource(options = {})
            (dataset_pages, dateset_resource) = 
              paginated_resource(objects_dataset, options)
            resource = {
              :id => pk,
              :firstname => firstname,
              :middlename => middlename,
              :lastname => lastname,
              :suffix => suffix,
              :display => displayname,
              :sort => alphasort,
              :dates => {
                :begin => begindate,
                :end => enddate,
                :display => displaydate
              },
              :has_bio => has_bio?,
              :objects => dateset_resource,
              :_links => self_link(dataset_pages, options)
            }
            if not options.include?('no_bio')
              resource[:bio] = bio
            end

            return resource
          end
        end
      end
    end
  end
end
