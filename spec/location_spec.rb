# Tests for Location class
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

require 'spec_helper'

describe MDL::Location do
  before :all do
    @loc = MDL::Location[2]
  end

  it "return rows" do
    # There are 54 locations as of Oct 2012
    MDL::Location.all().count.should be >= 54
  end

  context "with a known location" do
    before :all do
      Gugg::WebApi::Collection::Linkable::root = "http://u.r.i/collection"
      Gugg::WebApi::Collection::Linkable::map_path(
        Gugg::WebApi::Collection::Db::Location, 'locations'
      )
      Gugg::WebApi::Collection::Linkable::map_path(
        Gugg::WebApi::Collection::Db::Site, 'sites'
      )

      @loc = MDL::Location[2]
    end

    it "has an area" do
      @loc.area.should eq 'Ramp 1'
    end

    it 'has a location' do
      @loc.location.should eq 'Bay 11'
    end

    it 'has a related Site' do
      @loc.site.should be_an_instance_of MDL::Site
      @loc.site.sitename.should eq 'Solomon R. Guggenheim Museum'
    end
  end

  describe '#as_resource' do
    it 'returns a Hash' do
      @loc.as_resource.should be_an_instance_of Hash
    end
  end
end
