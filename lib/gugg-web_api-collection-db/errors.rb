# Interface to Language Code table.
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3
#
# The Language Code table maps TMS languages to ISO 639-1 equivalents

module Gugg
  module WebApi
    module Collection
      module Db
        class DbError < StandardError
        end

        class BadParameterError < DbError
        end
      end
    end
  end
end
