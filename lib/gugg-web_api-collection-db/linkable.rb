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

        def format_params(current, new={})
          # merge current and new parameters and throw out parameters that we 
          # don't wnat to repeat in the links we're going to construct
          no_repeat = ['no_objects'] 
          p = current.merge(new).reject{|k,v| no_repeat.include?(k)}

          # No parameters to format? Goodbye!
          if p.count == 0
            return ''
          end

          pairs = p.map{|k, v| "#{k}=#{v}"}
          query = pairs.join('&')
          return "?#{query}"
        end


        def self_link(options = {})
          path = [Linkable::root, Linkable::pathmap[self.class]].join('/')
          pagination = {}

          if @obj_pages != nil
            if ! @obj_pages.first_page?
              params = {
                :page => @obj_pages.prev_page, 
                :per_page => @obj_pages.page_size
              }
              q = format_params(options, params)
              pagination[:prev] = {
                :href => "#{path}/#{pk}#{q}"
              }
            end

            if ! @obj_pages.last_page?
              params = {
                :page => @obj_pages.next_page, 
                :per_page => @obj_pages.page_size
              }
              q = format_params(options, params)
              pagination[:next] = {
                :href => "#{path}/#{pk}#{q}"
              }
            end
          end

          q = format_params(options)
          {
            :_self => {
              :href => "#{path}/#{pk}#{q}"
            }
          }.merge!(pagination)
        end
      end
    end
  end
end
