# Interface to Sort Fields table.
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

module Gugg
  module WebApi
    module Collection
      module Db
        class SortFields < Sequel::Model(:collection_sort_fields)
          one_to_many :object, :class => CollectionObject, :key => :objectid
          one_to_one :objlocation, :class => Location, :primary_key => :location, :key => :section
        end
      end
    end
  end
end
