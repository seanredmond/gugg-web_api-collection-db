#
# @author Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3
#
# The Language Code table maps TMS languages to ISO 639-1 equivalents

module Gugg
  module WebApi
    module Collection
      module Db
        # An interface to the collection_tms_acquisitions table and its related 
        # objects.
        #
        # An acquisition is a named group of collection objects that came into
        # the collection together from a single source; for example, as a 
        # bequest from a donor whose name would be attached to the acquisition.
        #
        # For documentation of acquisition endpoints and resources, see
        # {https://github.com/Guggenheim/Collections-API-Spec/blob/master/acquisitions.md}
        # 
        # @author Sean Redmond <sredmond@guggenheim.org>
        # @copyright Copyright © 2012 Solomon R. Guggenheim Foundation
        # @license GPLv3
        class Acquisition < Sequel::Model(:collection_acquisitions)
          set_primary_key :acquisitionid
          many_to_many :objects, :class=>CollectionObject, 
            :join_table=>:collection_acquisitionxrefs, 
            :left_key=>:acquisitionid, :right_key=>:objectid
          include Linkable
          include Collectible

          # Returns a list of acquisitions
          #
          # @param [Hash] options A hash of options to be passed to 
          #   {#as_resource}
          # @return [Hash] A resource containing a list of acquisition 
          #   resources
          def self.list(options = {})
            defaults = {}
            if !options.keys.include?('per_page')
              defaults['no_objects'] = true
            end

            {
              :acquisitions => all.
                reject{|a| a.objects_dataset.count == 0}.
                map{|a| a.as_resource(defaults.merge!(options))}
            }
          end

          # Returns a representation of the acquisition in a hash suitable for
          # output as a JSON resource
          #
          # @param [Hash] options A hash of options to be passed to 
          #   {Collectible#paginated_resource} and {Linkable#self_link}
          # @return [Hash] The resource
          def as_resource(options = {})
            (dataset_pages, dateset_resource) = 
              paginated_resource(objects_dataset, options)

            {
              :id => pk,
              :name => acquisition,
              :objects => dateset_resource,
              :_links => self_link(dataset_pages, options)
            }
          end
        end
      end
    end
  end
end
