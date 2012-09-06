# Interface to Constituents table.
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

module Gugg
  module WebApi
    module Collection
      module Db
        class Constituent < Sequel::Model(:collection_tms_constituents)
          set_primary_key :constituentid
          many_to_many :objects, :class=>CollectionObject, 
            :join_table=>:collection_tms_conxrefs, 
            :left_key=>:constituentid, :right_key=>:id

          include Linkable
          include Collectible

          def after_initialize
            @obj_dataset = objects_dataset
            @obj_pages = nil
          end

          def as_resource(options = {})
            {
              :id => pk,
              :firstname => firstname,
              :middlename => middlename,
              :lastname => lastname,
              :suffix => suffix,
              :display => displayname,
              :sort => alphasort,
              :nationality => nationality,
              :dates => {
                :begin => begindate,
                :end => enddate,
                :display => displaydate
              },
              :objects => paginated_resource(options),
              :_links => self_link(options)
            }
          end
        end
      end
    end
  end
end
