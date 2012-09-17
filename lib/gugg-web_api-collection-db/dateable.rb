# Create API links
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

module Gugg
  module WebApi
    module Collection
      module Dateable
        def date_resource(begin_date, end_date, display_date)
        	{
        		:begin  => begin_date,
        		:end     => end_date,
        		:display => display_date
        	}
        end
      end
    end
  end
end
