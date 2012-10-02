# Interface to Exhibition cross-references table.
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

module Gugg
  module WebApi
    module Collection
      module Db
        class ExhibitionXref < Sequel::Model(:collection_tms_exhobjxrefs)
          many_to_one :object, :class => CollectionObject, :key => :objectid
          many_to_one :exhibition, :class => Exhibition, :key => :exhibitionid
        end
      end
    end
  end
end
