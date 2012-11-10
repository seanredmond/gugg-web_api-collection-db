# Tests for tables without any extra implementation beyond Sequel
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

require 'spec_helper'

describe MDL::Media do
  before :all do
    @pwb_img = MDL::Media[47568]
  end

  it "returns rows" do
    # There are 1044 media formats as of Nov 2012
    MDL::Media.all().count.should be >= 1044
  end

  describe "#as_resource" do
    before :all do
      @resource = @pwb_img.as_resource
    end

    it "is a Hash" do
      @resource.should be_an_instance_of Hash
    end

    it "gives the orientation" do
      @resource[:orientation].should eq 'landscape'
    end
  end


  context "landscape oriented image" do
    before :all do
      @landscape = MDL::Media[47378]
    end

    it "is landscape" do
      @landscape.orientation.should eq MDL::Media::ORIENTATION_LANDSCAPE
      @landscape.is_landscape?.should eq true
      @landscape.is_portrait?.should eq false
      @landscape.as_resource[:orientation].should eq 'landscape'
    end
  end

  context "portrait oriented image" do
    before :all do
      @portrait = MDL::Media[47380]
    end

    it "is portrait" do
      @portrait.orientation.should eq MDL::Media::ORIENTATION_PORTRAIT
      @portrait.is_landscape?.should eq false
      @portrait.is_portrait?.should eq true
      @portrait.as_resource[:orientation].should eq 'portrait'
    end
  end
end

describe MDL::MediaFormat do
  it "should return rows" do
    # There are 24 media formats as of Aug 2012
    MDL::MediaFormat.all().count.should be >= 24
  end

  it "should contain expected values" do
    MDL::MediaFormat[2].format.should eq('JPEG')
  end

  it "should be able to retrieve associated language code" do
    MDL::MediaFormat[2].type.mediatype.should eq('Image')
  end
end
