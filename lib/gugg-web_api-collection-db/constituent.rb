# Interface to Constituents table.
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

module Gugg
  module WebApi
    module Collection
      module Db
        class Constituent < Sequel::Model(:collection_tms_constituents)
        end
      end
    end
  end
end
