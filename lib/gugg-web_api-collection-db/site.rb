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

          def after_initialize
            @obj_dataset = objects_dataset
            @obj_pages = nil
          end


          # id 21 = 'Historical Images' which is not a real site
          set_dataset(dataset.filter(~:siteid =>  21))

          def as_resource(options = {})
            {
              :id => pk,
              :name => sitename,
              :location => sitenumber,
              :objects => paginated_resource(options),
              :_links => self_link(options)
            }
          end
        end
      end
    end
  end
end
