# Create API links
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

module Gugg
  module WebApi
    module Collection

      # Manage link resources for API objects
      #
      # @author Sean Redmond <sredmond@guggenheim.org>
      module Linkable
        # The root of API URLs
        @@root = nil

        # A hash that maps classes to paths in the API
        @@pathmap = {}        

        # Get the URL root.
        # @return [String] @@root
        def self.root
          @@root
        end

        # Set the URL root.
        # @param [String] r The root of API URLs
        # @return [String] the value set
        def self.root=(r)
          @@root = r
        end

        # Get the pathmap.
        # @return [Hash] @@pathmap
        def self.pathmap
          @@pathmap
        end

        # Set a class to path mapping.
        # @param [Class] cls The class
        # @param [String] path The path 
        # @return [String] The path set
        def self.map_path(cls, path)
          @@pathmap[cls] = path
        end

        # Return a links object. This method should be called directly only 
        # from class methods.An instance should use {#self_link} which will
        # call this method with the appropriate instance attributes as 
        # parameters.  
        #
        # @param [Class] cls The class of the object being linked
        # @param [Object] paginated_r A paginated dataset
        # @param pk If called by an instance, the primary key of the instance 
        #   being linked
        # @param [Hash] options Options to be passed to {#format_params}
        # @return [Hash] The link resource
        # @see #self_link
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

        # Return a formatted query string for inclusion in a URL
        #
        # @param [Hash] current The current options
        # @param [Hash] new New options to be merged into current before 
        #   formatting
        # @return [String] The formatted query string
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

        # Return a links object for an instance. 
        #
        # @param [Object] pages A paginated dataset
        # @param [Hash] options Options to be passed to {#make_links}
        # @return [Hash] The link resource
        # @see #make_links
        def self_link(pages = nil, options = {})
          return Linkable::make_links(self.class, pages, pk, options)
        end
      end
    end
  end
end
