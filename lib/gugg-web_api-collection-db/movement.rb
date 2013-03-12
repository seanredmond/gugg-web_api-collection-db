# Interface to Language Code table.
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3
#
# The Language Code table maps TMS languages to ISO 639-1 equivalents

module Gugg
  module WebApi
    module Collection
      module Db
        class Movement < Sequel::Model(:collection_movements)
          set_primary_key :termid
          many_to_many :objects, :class=>CollectionObject, 
            :join_table=>:collection_objmovementxrefs, 
            :left_key=>:termid, :right_key=>:id

          include Linkable
          include Collectible

          def self.list(options = {})
            defaults = {}
            if !options.keys.include?('per_page')
              defaults['no_objects'] = true
            end

            {
              :movements => order(:term).all.
                reject{|m| m.objects_dataset.count == 0}.
                map{|m| m.as_resource(defaults.merge!(options))}
            }
          end

          def name
            term
          end

          def as_resource(options = {})
            (dataset_pages, dateset_resource) = 
              paginated_resource(objects_dataset, options)
            {
              :id => pk,
              :name => name,
              :objects => dateset_resource,
              :_links => self_link(dataset_pages, options)
            }
          end
        end
      end
    end
  end
end
