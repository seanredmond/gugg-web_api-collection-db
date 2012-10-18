# Interface to Roles table.
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

module Gugg
  module WebApi
    module Collection
      module Db
        class CollectionObjectSearch
          include Collectible
          include Linkable

          def pk 
            nil  
          end

          def on_view(options = {})
            @obj_dataset = CollectionObject.where(:objectid => 
              SortFields.select(:objectid).where(~ :location => nil))
            @obj_pages = nil
            {
              :objects => paginated_resource(options),
              :_links => self_link(options)              
            }
          end
        end
      end
    end
  end
end
