require "gugg-web_api-collection-db/errors"
require "gugg-web_api-collection-db/linkable"
require "gugg-web_api-collection-db/collectible"
require "gugg-web_api-collection-db/dateable"
require "gugg-web_api-collection-db/version"
require "gugg-web_api-collection-db/language_code"
require "gugg-web_api-collection-db/language"
require "gugg-web_api-collection-db/media_type"
require "gugg-web_api-collection-db/media_format"
require "gugg-web_api-collection-db/media"
require "gugg-web_api-collection-db/object_context"
require "gugg-web_api-collection-db/role"
require "gugg-web_api-collection-db/text_entry"
require "gugg-web_api-collection-db/title_type"
require "gugg-web_api-collection-db/object_title"
require "gugg-web_api-collection-db/collection_object"
require "gugg-web_api-collection-db/object_type"
require "gugg-web_api-collection-db/exhibition"
require "gugg-web_api-collection-db/exhibition_xref"
require "gugg-web_api-collection-db/site"
require "gugg-web_api-collection-db/location"
require "gugg-web_api-collection-db/acquisition"
require "gugg-web_api-collection-db/movement"
require "gugg-web_api-collection-db/sort_fields"
require "gugg-web_api-collection-db/constituent"
require "gugg-web_api-collection-db/constituent_xref"

Sequel.extension :pagination

module Gugg
  module WebApi
    module Collection
      module Db
        # Your code goes here...

        def self.date_resource(begin_date, end_date, display)
          {
            :begin => begin_date,
            :end => (end_date == nil || end_date == 0) ? nil : end_date,
            :display => display
          }
        end
      end
    end
  end
end
