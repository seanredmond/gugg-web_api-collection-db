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
        class Movement < Sequel::Model(:collection_movements)
          set_primary_key :termid
          many_to_many :objects, :class=>CollectionObject, 
            :join_table=>:collection_objmovementxrefs, 
            :left_key=>:termid, :right_key=>:id

          include Linkable
          include Collectible

          def after_initialize
            @obj_dataset = objects_dataset
            @obj_pages = nil
          end

          def self.list(options = {})
            {
              :movements => all.
                reject{|m| m.objects_dataset.count == 0}.
                map{|m| m.as_resource({'per_page' => 5}.merge!(options))}
            }
          end

          def name
            term
          end

          def as_resource(options = {})
            objects_r = paginated_resource(objects_dataset, options)      
            {
              :id => pk,
              :name => name,
              :objects => objects_r,
              :_links => self_link(options)
            }
          end
        end
      end
    end
  end
end
