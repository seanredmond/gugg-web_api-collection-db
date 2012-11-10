#
# @author Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3
#
# Interface to Object Images table.

module Gugg
  module WebApi
    module Collection
      module Db
        # An interface to the collection_object_images table and its related 
        # objects.
        #
        # Currently, each object only has one image in the database, and only
        # full-size version of theimage is listed. Other image sizes are 
        # calculated by this class
        # 
        # @author Sean Redmond <sredmond@guggenheim.org>
        # @copyright Copyright © 2012 Solomon R. Guggenheim Foundation
        # @license GPLv3
        class Media < Sequel::Model(:collection_object_images)
          many_to_one :format, 
            :class => Gugg::WebApi::Collection::Db::MediaFormat, 
              :key => :mediatypeid  
        end
      end
    end
  end
end
