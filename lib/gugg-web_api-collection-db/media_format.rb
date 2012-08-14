# Interface to Media Formats table.
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

module Gugg
  module WebApi
    module Collection
      module Db
        class MediaFormat < Sequel::Model(:collection_tms_mediaformats)
          many_to_one :type, 
            :class => Gugg::WebApi::Collection::Db::MediaType, :key => :mediatypeid  
        end
      end
    end
  end
end
