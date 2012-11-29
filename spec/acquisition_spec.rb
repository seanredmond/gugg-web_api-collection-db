# Tests for tables without any extra implementation beyond Sequel
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

require 'spec_helper'

describe MDL::Acquisition do
  describe "One Acquisition object" do
    before :all do 
      # Solomon R. Guggenheim Collection
      @acq = MDL::Acquisition[4]
    end

    it "should be an Acquisition" do
      @acq.should be_an_instance_of MDL::Acquisition
    end

    it "should have the right ID" do
      @acq.pk.should eq 4
    end

    it "should have the right name" do
      @acq.acquisition.should eq 'Thannhauser Collection'
    end
  end

  describe "#as_resource" do
    before :all do
      # Solomon R. Guggenheim Collection
      @acq = MDL::Acquisition[6]
    end

    context "with defaults" do
      before :all do 
        @res = @acq.as_resource
      end

      it "should return a Hash" do
        @res.should be_an_instance_of Hash
      end

      it "should have objects" do
        @res[:objects].should be_an_instance_of Hash
      end
    end

    context "with options" do
      context "for page" do
        before :all do
          @res = @acq.as_resource({'page' => 2})
        end

        it "should return page 2" do
          @res[:objects][:page].should eq 2
        end
      end
    end
  end


  describe ".List" do
    context "with defaults" do
      before :all do
        @acq = MDL::Acquisition.list
      end

      it "should return a Hash" do
        @acq.should be_an_instance_of Hash
      end

      it "has a list of Acquisition resources" do
        @acq[:acquisitions].each do |a|
          a.should be_an_instance_of Hash
          a[:id].should be
          a[:name].should be
        end
      end

      it "should have Acquisition resources with no items" do
        @acq[:acquisitions].each do |a|
          a[:objects][:items].should_not be
        end
      end
    end

    context "with options" do
      context "for items per page" do
        before :all do
          @acq = MDL::Acquisition.list({'per_page' => 10})
        end

        it "should have Acquisition resources with 10 items" do
          @acq[:acquisitions].each do |a|
            a[:objects][:items].should have_at_least(1).items
            a[:objects][:items].should have_at_most(10).items
          end
        end
      end
      
      context "with no_objects" do
        before :all do
          @acq = MDL::Acquisition.list({'no_objects' => 1})
        end

        it "should have Acquisition resources without objects" do
          @acq[:acquisitions].each do |a|
            a[:objects][:items].should be_nil
          end
        end

        it "should have Acquisition objects with counts" do
          @acq[:acquisitions].each do |a|
            a[:objects][:total_count].should be >= 1
          end
        end
      end
    end
  end
end
