# Tests for date resources
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

require 'spec_helper'

describe "MDL::CollectionObjectSearch.on_view" do
  it "should return a Hash" do
  	s = MDL::CollectionObject
  	s.on_view.should be_an_instance_of(Hash)
  end
end
