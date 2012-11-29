# Tests for Exhibitions
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

require 'spec_helper'

describe MDL::Exhibition do
  before :all do
    @current = MDL::Exhibition[2]
  end

  it "has objects" do
    @current.objects.count.should eq 3
  end

  it "should have Guggenheim objects" do
    @current.ours.count.should eq 2
  end

  it "should have non Guggenheim objects" do
    @current.not_ours.count.should eq 1
  end

  describe "#name" do
    it "should have a name" do
      @current.name.should eq "Current Exhibition"
    end
  end

  describe "#as_resource" do
    it "should work" do
      @current.should be_an_instance_of MDL::Exhibition
    end

    context "with defaults" do
      before :all do 
        @res = MDL::Exhibition[2].as_resource
      end

      it "should return a Hash" do
        @res.should be_an_instance_of Hash
      end

      it "has an id" do
        @res[:id].should eq 2
      end

      it "should have objects" do
        @res[:objects].should be_an_instance_of Hash
      end
    end
  end

  describe ".list" do
    context "with defaults" do
      before :all do
        @exh = MDL::Exhibition.list
      end
      it "should return a Hash" do
        @exh.should be_an_instance_of Hash
      end

      it "should have a list of Exhibition resources" do
        @exh[:exhibitions].each do |e|
          e.should be_an_instance_of Hash
          e[:name].should be
          e[:dates].should be
          e[:objects].should be
          e[:_links].should be
        end
      end
    end
  end
end
