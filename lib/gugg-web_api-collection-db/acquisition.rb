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
        class Acquisition < Sequel::Model(:collection_acquisitions)
          set_primary_key :acquisitionid
          many_to_many :objects, :class=>CollectionObject, 
            :join_table=>:collection_acquisitionxrefs, 
            :left_key=>:acquisitionid, :right_key=>:objectid
          include Linkable

          def self.list
            {
              :acquisitions => all.
                reject{|a| a.objects_dataset.count == 0}.
                map{|a| a.as_resource({:per_page => 5})}
            }
          end

          def as_resource(options = {})
            objects_r = objects_dataset.paginate(1, 5)          
            {
              :id => pk,
              :name => acquisition,
              :objects => objects_r.map { |o| o.as_resource },
              :_links => self_link
            }
          end
        end
      end
    end
  end
end
