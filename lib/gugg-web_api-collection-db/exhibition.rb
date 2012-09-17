# Interface to Exhibitions table.
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

module Gugg
  module WebApi
    module Collection
      module Db
        class Exhibition < Sequel::Model(:collection_tms_exhibitions)
          set_primary_key :exhibitionid
          include Linkable
          include Collectible
          include Dateable

          def as_resource(options = {})
            {
              :id => pk,
              :name => exhtitle,
              :dates => date_resource(beginisodate, endisodate, displaydate),
              :_links => self_link(options)
            }
          end
        end
      end
    end
  end
end
