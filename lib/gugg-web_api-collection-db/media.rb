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
          set_primary_key :mediaxrefid
          many_to_one :format, 
            :class => Gugg::WebApi::Collection::Db::MediaFormat, 
              :key => :mediatypeid

            ORIENTATION_LANDSCAPE = 0
            ORIENTATION_PORTRAIT  = 1

          # Returns a representation of the media object in a hash suitable for
          # output as a JSON resource
          #
          # @param [Hash] options A hash of options to be passed to 
          #   {Collectible#paginated_resource} and {Linkable#self_link}
          # @return [Hash] The resource
          def as_resource(options = {})
            (dataset_pages, dateset_resource) = 
              paginated_resource(objects_dataset, options)

            {

            }
          end

          # Returns a constant indicating the orientation of the image
          #
          # @return [Boolean] ORIENTATION_LANDSCAPE if the width it greater than
          #   or equal to the height, ORIENTATION_PORTRAIT if the height is
          #   greater than the width. NB: a square image will be called 
          #   landscape
          def orientation
            if pixelw >= pixelh
              return ORIENTATION_LANDSCAPE
            end

            return ORIENTATION_PORTRAIT
          end

          # Answers the question, "Is this image landscape?"
          #
          # @return [Boolean] True if the width of the image is greater than or
          #   equal to the height. NB: This will return true for square images.
          def is_landscape?
            return orientation == ORIENTATION_LANDSCAPE
          end

          # Answers the question, "Is this image portrait?"
          #
          # @return [Boolean] True if the height of the image is greater than 
          #   the width. NB: This will return false for square images.
          def is_portrait?
            return orientation == ORIENTATION_PORTRAIT
          end
        end 
      end
    end
  end
end
