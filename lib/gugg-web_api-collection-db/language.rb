# Interface to Languages table.
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

module Gugg
  module WebApi
    module Collection
      module Db
        class Language < Sequel::Model(:collection_tms_languages)
          one_to_one :languages, 
            :class => Gugg::WebApi::Collection::Db::LanguageCode, 
            :key => :languageid
          # one_to_many :collection_tms_objtitles, :class => :ObjectTitle, :key => :languageid
        end
      end
    end
  end
end
