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
          pages = @obj_dataset.paginate(1, 7)
          {
            :page => pages.current_page,
            :pages => pages.page_count,
            :items_per_page => pages.page_size,
            :count => pages.count,
            :total_count => pages.pagination_record_count,
            :items => pages.count > 0 ? pages.map{|i| i.as_resource} : nil
          }
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
