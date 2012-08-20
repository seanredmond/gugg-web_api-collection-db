# Create API links
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

module Gugg
  module WebApi
    module Collection
      module Collectible
        attr :obj_dataset

        def paginated_objects
          @obj_dataset.paginate(1, 7)
        end

        def self_link
          path = [Linkable::root, Linkable::pathmap[self.class]].join('/')
          {
            :_self => {
              :href => "#{path}/#{pk} "
            }
          }
        end
      end
    end
  end
end
