# Handle paginated lists of CollectionObject objects
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

module Gugg
  module WebApi
    module Collection
      module Collectible
        attr :obj_dataset

        def page_option_or_default(options = {})
          begin
            return options['page'] == nil ? 1 : Integer(options['page'])
          rescue ArgumentError => e
            raise Db::BadParameterError, e.message
          end
        end

        def per_page_option_or_default(options)
          begin
            return options['per_page'] == nil ? 
              20 : Integer(options['per_page'])
          rescue ArgumentError => e
            raise Db::BadParameterError, e.message
          end
        end

        # Paginates the {@obj_dataset} dataset according to the per_page option
        # (or default) and returns a hash representing a paginated object 
        # resource. Uses Sequel::Dataset#paginate for pagination.
        # 
        # Unless the 'no_objects' option is passed, the returned Hash will 
        # contain the following members:
        # * :page The current page of the result set
        # * :pages The total number of pages in the result set
        # * :items_per_page The number of items in each page
        # * :count The number of items in the current page,
        # * :total_count The total number of items in all the pages of the 
        #   result,
        # * :items An array of objects 
        #
        # If the 'no_objects' parameter is passed, the returned Hash will 
        # contain only the :total_count.
        #
        # @param [Object] dset The dataset to be paginated 
        # @param [Hash] options The options for pagination. Note that keys must 
        # be Strings since we actually expecting them to come from query 
        # parameters originating in URLs as calls to an API (which will be 
        # passed as Strings)
        #
        # @option options [Integer] 'page' The page of results to return
        # @option options [Integer] 'per_page' The number of items in each page
        # @option options 'no_objects' If this option is passed with any value 
        # (even nil), the result will contain only a total count of items, not 
        # a paginated dataset
        # @return [Hash] The paginated resource.
        def paginated_resource(dset, options = {})
          if options.keys.include?('no_objects')
            @obj_pages = nil
            return {
              :total_count => dset.count
            }
          end

          begin
            # page = options['page'] == nil ? 1 : Integer(options['page'])
            # per_page = options['per_page'] == nil ? 
            #   20 : Integer(options['per_page'])
            page = page_option_or_default(options)
            per_page = per_page_option_or_default(options)
          rescue ArgumentError => e
            raise Db::BadParameterError, e.message
          end

          if @obj_pages == nil || 
              @obj_pages.current_page != page || 
              @obj_pages.page_size != per_page
            @obj_pages = dset.paginate(page, per_page)
          end

          {
            :page => @obj_pages.current_page,
            :pages => @obj_pages.page_count,
            :items_per_page => @obj_pages.page_size,
            :count => @obj_pages.count,
            :total_count => @obj_pages.pagination_record_count,
            :items => @obj_pages.count > 0 ? 
              @obj_pages.map{|i| i.as_resource} : nil
          }
        end
      end
    end
  end
end
