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
          def as_resource
            {
              :id => pk,
              :firstname => firstname,
              :middlename => middlename,
              :lastname => lastname,
              :suffix => suffix,
              :display => displayname,
              :sort => alphasort,
              :nationality => nationality,
              :dates => {
                :begin => begindate,
                :end => enddate,
                :display => displaydate
              },
              :objects => {}
            }
          end
        end
      end
    end
  end
end
