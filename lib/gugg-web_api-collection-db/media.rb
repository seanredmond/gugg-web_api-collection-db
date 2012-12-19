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
          many_to_one :mediaformat, 
            :class => Gugg::WebApi::Collection::Db::MediaFormat, 
              :key => :formatid

          ORIENTATION_LANDSCAPE = 0
          ORIENTATION_PORTRAIT  = 1

          @@media_root = nil
          @@media_paths = {}
          @@media_dimensions = {}

          # Get the media root.
          # @return [String] @@image_root
          def self.media_root
            @@media_root
          end

          # Set the media root.
          # @return [String] @@image_root
          def self.media_root=(r)
            @@media_root = r
          end

          # Get the media paths.
          # @return [Hash] @@image_paths
          def self.media_paths
            @@media_paths
          end

          # Set the media paths.
          # @return [Hash] @@image_paths
          def self.media_paths=(p)
            @@media_paths = p
          end

          # Get the media dimensions.
          # @return [Hash] @@image_dimensions
          def self.media_dimensions
            @@media_dimensions
          end

          # Set the media paths.
          # @return [Hash] @@image_paths
          def self.media_dimensions=(d)
            @@media_dimensions = d
          end

          # Returns a representation of the media object in a hash suitable for
          # output as a JSON resource
          #
          # @param [Hash] options A hash of options to be passed to 
          #   {Collectible#paginated_resource} and {Linkable#self_link}
          # @return [Hash] The resource
          def as_resource(options = {})
            # (dataset_pages, dateset_resource) = 
            #   paginated_resource(objects_dataset, options)

            {
              :orientation => is_landscape? ? 'landscape' : 'portrait',
              :type => media_type,
              :format => media_format,
              :rank => rank,
              :copyright => copyright,
              :assets => sizes
            }
          end

          # Get the available image sizes
          #
          # @return [Hash] A hash containing the various available images sizes,
          #   with dimensions and links
          def sizes
            sz = {
              :full => {
                :width => pixelw,
                :height => pixelh,
                :_links => {
                  :_self => {
                    :href => media_url(:full)
                  }
                }
              }
            }

            @@media_dimensions.keys.map do |s|
              sz[s] = {
                :width => dimensions(s)[:width],
                :height => dimensions(s)[:height],
                :_links => {
                  :_self => {
                    :href => media_url(s)
                  }
                }
              }
            end

            return sz
          end

          # Get the format of the media
          #
          # @return [String] The media format (i.e. jpeg)
          def media_format
            return mediaformat.format
          end


          # Get the type of the media
          #
          # @return [String] The media type (i.e. image)
          def media_type
            return mediaformat.mediatype.mediatype
          end

          def media_path(size)
            if @@media_paths[size] == nil
              return nil
            end
            return [@@media_root, @@media_paths[size]].join('/')
          end

          def media_url(size)
            path = media_path(size)
            return path == nil ? nil : [path, filename].join('/')
          end

          def dimensions(size)
            if size == :full
              ratio = 1
            else 
              max_dim = @@media_dimensions[size]

              if max_dim == nil
                return nil
              end

              if is_landscape?
                ratio = max_dim.to_f/pixelw
              else
                ratio = max_dim.to_f/pixelh
              end
            end

            begin
              return {
                :width => (pixelw * ratio).round,
                :height => (pixelh * ratio).round
              }
            rescue FloatDomainError => e
              return {
                :width => 0,
                :height => 0
              }
            end
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
