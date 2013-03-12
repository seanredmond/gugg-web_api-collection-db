# Tests for Movements
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

require 'spec_helper'

describe MDL::Movement do
  it "should return rows" do
    # There are 38 acquisitions as of Aug 2012
    MDL::Movement.all().count.should be >= 38
  end

  describe "One Movement object" do
    before :all do 
      # Abstract Expressionism
      @mov = MDL::Movement[195203]
    end

    it "should be a Movement" do
      @mov.should be_an_instance_of MDL::Movement
    end

    it "should have the right ID" do
      @mov.pk.should eq 195203
    end

    it "should have the right name" do
      @mov.name.should eq 'Abstract Expressionism'
    end
  end

  describe ".List" do
    context "with defaults" do
      before :all do
        @mov = MDL::Movement.list
      end

      it "should return a Hash" do
        @mov.should be_an_instance_of Hash
      end

      it "has a list of Acquisition resources" do
        @mov[:movements].each do |a|
          a.should be_an_instance_of Hash
          a[:id].should be
          a[:name].should be
        end
      end

      it "should have Movement resources with 5 items" do
        @mov[:movements].each do |a|
          a[:objects][:items].should_not be
        end

      end

      it "should be in the right order" do
        # By id, the third movement is School of Expressionism
        @mov[:movements].map{|m| m[:name] }[0..2].
          should eq ["Bauhaus", "Cubism", "Expressionism"]
      end
    end
  end

  describe "#as_resource" do
    before :all do
      # Solomon R. Guggenheim Collection
      @mov = MDL::Movement[195203]
    end

    context "with defaults" do
      before :all do 
        @res = @mov.as_resource
      end

      it "should return a Hash" do
        @res.should be_an_instance_of Hash
      end

      it "has an id" do
        @res[:id].should eq 195203
      end

      it "should have objects" do
        @res[:objects].should be_an_instance_of Hash
      end
    end
  end
end
