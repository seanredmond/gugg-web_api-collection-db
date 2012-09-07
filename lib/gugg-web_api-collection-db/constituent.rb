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

          include Linkable
          include Collectible

          def after_initialize
            @obj_dataset = objects_dataset
            @obj_pages = nil
          end

          dataset_module do
            def all
              filter()
            end

            def publicview
              filter(:conxrefs => ConstituentXref.filter(:displayed => 1)).
              filter(:objects => CollectionObject.filter(
                :publicaccess => 1, :curatorapproved => 1))
            end
          end

          set_dataset(self.publicview)

          def self.list(options = {})
            if options.keys.include?('initial')
              begin
                match = options['initial'].match(/^[a-zA-Z]$/)
                if match != nil
                  selection = where(:alphasort.ilike("#{match[0]}%")).
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
              selection = all
            end

            {
              :constituents => selection.
                map{|a| a.as_resource({'no_objects' => true}.merge!(options))}
            }
          end

          def as_resource(options = {})
            {
              :id => pk,
              :firstname => firstname,
              :middlename => middlename,
              :lastname => lastname,
              :suffix => suffix,
              :display => displayname,
              :sort => alphasort,
              :nationality => nationality,
              :dates => {
                :begin => begindate,
                :end => enddate,
                :display => displaydate
              },
              :objects => paginated_resource(options),
              :_links => self_link(options)
            }
          end
        end
      end
    end
  end
end
