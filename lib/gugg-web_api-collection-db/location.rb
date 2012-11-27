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
          set_primary_key :section

          # Returns a representation of the loaction in a hash suitable for
          # output as a JSON resource
          #
          # @param [Hash] options A hash of options to be passed to 
          #   {Collectible#paginated_resource} and {Linkable#self_link}
          # @return [Hash] The resource
          def as_resource(options = {})
            {
              :id => pk,
              :venue => site.sitename,
              :area => area,
              :location => location
            }
          end
        end
      end
    end
  end
end
