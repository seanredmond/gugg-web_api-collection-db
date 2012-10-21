module Gugg
  module WebApi
    module Collection
      module Db
        # An interface to the collection_locations table and its related 
        # objects.
        # 
        # @author Sean Redmond <sredmond@guggenheim.org>
        # Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
        # License GPLv3
        class Location < Sequel::Model(:collection_locations)
          many_to_one :site, :class => Site, :key => :siteid
        end
      end
    end
  end
end
