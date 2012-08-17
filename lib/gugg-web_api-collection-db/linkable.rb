# Create API links
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

module Gugg
  module WebApi
    module Collection
      module Linkable
        @@pathmap = {}
        @@root = nil

        def self.root
          @@root
        end

        def self.root=(r)
          @@root = r
        end

        def self.pathmap
          @@pathmap
        end

        def self.map_path(cls, path)
          @@pathmap[cls] = path
        end

        def self_link
          path = [Linkable::root, Linkable::pathmap[self.class]].join('/')
          {
            :_self => {
              :href => "#{path}/#{pk} "
            }
          }
        end
      end
    end
  end
end
