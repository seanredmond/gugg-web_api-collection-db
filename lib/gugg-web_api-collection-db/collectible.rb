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

        def paginated_resource(options = {})
          if options.keys.include?('no_objects')
            @obj_pages = nil
            return {
              :total_count => @obj_dataset.count
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
            @obj_pages = @obj_dataset.paginate(page, per_page)
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
