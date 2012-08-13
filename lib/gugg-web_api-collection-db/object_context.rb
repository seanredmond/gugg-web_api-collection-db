# Interface to Object Context table.
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3
#
# The Object Context table contains various flags relevant to object records.

module Gugg
  module WebApi
    module Collection
      module Db
        class ObjectContext < Sequel::Model(:collection_tms_objcontext)
        end
      end
    end
  end
end
