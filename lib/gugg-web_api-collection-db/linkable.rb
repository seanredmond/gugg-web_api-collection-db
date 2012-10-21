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

        def self.make_links(cls = nil, paginated_r = nil, pk = nil, options = {})
          path = [@@root, @@pathmap[cls], options[:add_to_path]].reject{|a| a == nil}.join('/')

          pagination = {}
          if paginated_r != nil
            if ! paginated_r.first_page?
              params = {
                :page => paginated_r.prev_page, 
                :per_page => paginated_r.page_size
              }
              q = format_params(options, params)
              pagination[:prev] = {
                :href => "#{path}/#{pk}#{q}"
              }
            end

            if ! paginated_r.last_page?
              params = {
                :page => paginated_r.next_page, 
                :per_page => paginated_r.page_size
              }
              q = format_params(options, params)
              pagination[:next] = {
                :href => "#{path}/#{pk}#{q}"
              }
            end
          end

          {
            :_self => {
              :href => "#{path}/#{pk}"
            }
          }.merge!(pagination)

        end

        def self.format_params(current, new={})
          # merge current and new parameters and throw out parameters that we 
          # don't wnat to repeat in the links we're going to construct
          no_repeat = ['no_objects', :add_to_path] 
          p = current.merge(new).reject{|k,v| no_repeat.include?(k)}

          # No parameters to format? Goodbye!
          if p.count == 0
            return ''
          end

          pairs = p.map{|k, v| "#{k}=#{v}"}
          query = pairs.join('&')
          return "?#{query}"
        end

        def self_link(pages = nil, options = {})
          return Linkable::make_links(self.class, pages, pk, options)
        end
      end
    end
  end
end
