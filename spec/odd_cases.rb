# Tests for odd and unique cases in the data
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

require 'spec_helper'

# More than on site: You would expect each object to belong to one site (that 
# is, one museum affiliate). One piece, however, Robert Rauschenberg's "Barge"
# belongs to both SRGM in New York and Guggenheim Bilbao
describe "Rauschenberg's 'Barges'" do
  before :all do
    @barges = MDL::CollectionObject[3547]
  end

  it "should have two sites" do
    @barges.sites.count.should eq 2
  end
end

describe "Objects with more than one site" do
	it "should exist" do
		MDL::CollectionObject.all.select{|o| o.sites.count > 1}.
			should have_at_least(1).items
	end
end
