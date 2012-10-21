# Interface to Exhibitions table.
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

module Gugg
  module WebApi
    module Collection
      module Db
        class Exhibition < Sequel::Model(:collection_tms_exhibitions)
          set_primary_key :exhibitionid
          many_to_many :objects, :class=>CollectionObject, 
            :join_table=>:collection_tms_exhobjxrefs, 
            :left_key=>:exhibitionid, :right_key=>:objectid

          include Linkable
          include Collectible
          include Dateable

          def after_initialize
            @obj_dataset = objects_dataset
            @obj_pages = nil
          end

          def self.list(options = {})
            {
              :exhibitions => all.
                reject{|m| m.objects_dataset.count == 0}.
                map{|m| m.as_resource({'per_page' => 5}.merge!(options))}
            }
          end

          def name
            exhtitle
          end

          def ours
            objects_dataset.where(~ :departmentid => 7)
          end

          def not_ours
            objects_dataset.where(:departmentid => 7)
          end

          def as_resource(options = {})
            objects_r = paginated_resource(objects_dataset, options)
            {
              :name => name,
              :dates => date_resource(beginisodate, endisodate, displaydate),
              :objects => objects_r,
              :_links => self_link(options)
            }
          end
        end
      end
    end
  end
end
