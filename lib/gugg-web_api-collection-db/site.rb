# Interface to Sites table.
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

module Gugg
  module WebApi
    module Collection
      module Db
        class Site < Sequel::Model(:collection_tms_sites)
          set_primary_key :siteid
          many_to_many :objects, :class=>CollectionObject, 
            :join_table=>:collection_objsitexrefs, 
            :left_key=>:siteid, :right_key=>:objectid
          include Linkable
          include Collectible

          # id 21 = 'Historical Images' which is not a real site
          set_dataset(dataset.filter(
            ~:siteid.qualify(:collection_tms_sites) =>  21))

          # def after_initialize
          #   @obj_dataset = objects_dataset
          #   @obj_pages = nil
          # end

          def self.list(options = {})
            defaults = {}
            if !options.keys.include?('per_page')
              defaults['no_objects'] = true
            end

            {
              :sites => all.
                reject{|a| a.objects_dataset.count == 0}.
                map{|a| a.as_resource(defaults.merge!(options))}
            }
          end

          def name
            sitename
          end

          def location
            sitenumber
          end

          def as_resource(options = {})
            (dataset_pages, dateset_resource) = 
              paginated_resource(objects_dataset, options)
            {
              :id => pk,
              :name => sitename,
              :location => sitenumber,
              :objects => dateset_resource,
              :_links => self_link(dataset_pages, options)
            }
          end
        end
      end
    end
  end
end
