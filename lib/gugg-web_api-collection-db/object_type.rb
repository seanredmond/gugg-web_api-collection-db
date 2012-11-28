#
# @author Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3
#
# The Object Types table maps Collection Objects to the kind of object they are.

module Gugg
  module WebApi
    module Collection
      module Db
        # An interface to the collection_objtypes table and its related 
        # objects.
        #
        # An object type is similar to medium but broader. For instance 
        # 'Painting' is the object type that covers oil, acrylics, etc.
        #
        # For documentation of acquisition endpoints and resources, see
        # {https://github.com/Guggenheim/Collections-API-Spec/blob/master/object_types.md}
        # 
        # @author Sean Redmond <sredmond@guggenheim.org>
        # @copyright Copyright © 2012 Solomon R. Guggenheim Foundation
        # @license GPLv3
        class ObjectType < Sequel::Model(:collection_objtypes)
          set_primary_key :termid
          many_to_many :objects, :class=>CollectionObject, 
            :join_table=>:collection_objtypexrefs, 
            :left_key=>:termid, :right_key=>:id

          # @return [String] The name of the object type
          def name
            term
          end

        # Returns a representation of the object type in a hash suitable for
        # output as a JSON resource
        #
        # @param [Hash] options A hash of options to be passed to 
        #   {Collectible#paginated_resource} and {Linkable#self_link}
        # @return [Hash] The resource
        def as_resource(options = {})
          # (dataset_pages, dateset_resource) = 
          #   paginated_resource(objects_dataset, options)

          {
            :id => pk,
            :name => term
            # :objects => dateset_resource,
            # :_links => self_link(dataset_pages, options)
          }
        end
        end
      end
    end
  end
end

