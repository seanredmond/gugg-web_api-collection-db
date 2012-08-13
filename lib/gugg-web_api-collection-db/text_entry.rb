# Interface to Text Entries table.
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3
#
# The Text Entry contains artist's biographies.

module Gugg
  module WebApi
    module Collection
      module Db
        class TextEntry < Sequel::Model(:collection_tms_textentries)
        end
      end
    end
  end
end
