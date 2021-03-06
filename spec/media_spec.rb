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

  it "has a rank" do
    @pwb_img.rank.should eq 1
  end

  it "has a copyright" do
    @pwb_img.keys.include?(:copyright).should be_true
  end

  describe "#sizes" do 
    before :all do
      @sizes = @pwb_img.sizes
    end

    it "is a Hash" do 
      @sizes.should be_an_instance_of Hash
    end

    context "full size" do
      before :all do
        @full = @sizes[:fullsize]
      end

      it "has a full size" do
        @full.should be
      end

      it "should have the dimensions of the object" do
        @full[:width].should eq @pwb_img.pixelw
        @full[:height].should eq @pwb_img.pixelh
      end
    end
  end

  describe "#format" do
    it "is a jpeg" do
      @pwb_img.media_format.should eq "JPEG"
    end
  end

  describe "#type" do
    it "is an image" do
      @pwb_img.media_type.should eq "Image"
    end
  end

  describe "#media_path" do
    context "with existing size" do
      it "has a path" do
        @pwb_img.media_path(:fullsize).
          should eq 'http://emuseum2.guggenheim.org/media/fullsize'
      end
    end

    context "with non-existing size" do
      it "does not have a path" do
        @pwb_img.media_path('nosuchsize').should be_nil
      end
    end
  end

  describe "#media_url" do
    context "with existing size" do
      it "has a url" do
        @pwb_img.media_url(:fullsize).
          should  eq 'http://emuseum2.guggenheim.org/media/fullsize/37.245_ph_web.jpg'
      end
    end

    context "with non-existing size" do
      it "does not have a url" do
        @pwb_img.media_url('nosuchsize').should be_nil
      end
    end
  end

  describe "#dimensions" do 
    it "has the right full size" do
      @pwb_img.dimensions(:full)[:width].should eq 573
    end

    it "has the right large size" do
      @pwb_img.dimensions(:biggest)[:width].should eq 490
    end

    it "has the right tiny size" do
      @pwb_img.dimensions(:smallest)[:width].should eq 62
    end
  end

  describe "#as_resource" do
    before :all do
      @resource = @pwb_img.as_resource
    end

    it "is a Hash" do
      @resource.should be_an_instance_of Hash
    end

    it "has format" do
      @resource[:format].should_not be_nil
    end

    it "has type" do
      @resource[:type].should_not be_nil
    end

    it "gives the orientation" do
      @resource[:orientation].should eq 'landscape'
    end

    it "has assets" do
      @resource[:assets].should be_an_instance_of Hash
    end

    it "has the right full size" do
      @resource[:assets][:fullsize][:width].should eq 573
    end

    it "has the right url for the full size" do
      @resource[:assets][:fullsize][:_links][:_self][:href].
        should eq 'http://emuseum2.guggenheim.org/media/fullsize/37.245_ph_web.jpg'
    end

    it "has a rank" do
      @resource[:rank].should eq 1
    end

    it "has a copyright" do
      @resource.keys.include?(:copyright).should be_true
    end
  end


  context "landscape oriented image" do
    before :all do
      @landscape = MDL::Media[47797]
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
      @portrait = MDL::Media[47590]
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
    MDL::MediaFormat[2].mediatype.mediatype.should eq('Image')
  end
end

describe "media ranking" do
  before :all do
    @ranked = MDL::CollectionObject[28732]
  end

  it "has 5 media records" do
    @ranked.media.count.should eq 5
  end

  it "has images in the correct order" do
    @ranked.media.first.rank.should eq 1
    @ranked.media.last.rank.should eq 5
  end
end
