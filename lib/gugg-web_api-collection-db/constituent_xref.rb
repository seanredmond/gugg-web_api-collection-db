# Interface to Constituent cross-references table.
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

module Gugg
  module WebApi
    module Collection
      module Db
        class ConstituentXref < Sequel::Model(:collection_tms_conxrefs)
          many_to_one :object, :class => CollectionObject, :key => :id
          many_to_one :constituent, :class => Constituent, :key => :constituentid
          many_to_one :role, :class => Role, :key => :roleid

          def as_resource(options = {})
            {
              :order => displayorder,
              :role => role.role,
              :constituent => constituent.as_resource(options)
            }
          end
        end
      end
    end
  end
end
