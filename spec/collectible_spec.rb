# Tests for tables without any extra implementation beyond Sequel
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

require 'spec_helper'

describe Gugg::WebApi::Collection::Collectible do
  before :all do
    # Thannhauser Collection, 26 objects
    @acq = MDL::Acquisition[4]
  end

  describe "#paginated_resource" do
    context "with defaults" do
      before :all do 
        (pages, @objects) = @acq.paginated_resource(@acq.objects_dataset)
      end

      it "should return a Hash" do
        @objects.should be_an_instance_of Hash
      end

      it "should have an :item property that is an Array" do
        @objects[:items].should be_an_instance_of Array
      end

      it "should have an Array of Hashes" do
        @objects[:items].each do |o|
          o.should be_an_instance_of Hash
        end
      end

      it "should return 20 items" do
        @objects[:items].count.should eq 20
        @objects[:items_per_page].should eq 20
      end

      it "should return page 1" do
        @objects[:page].should eq 1
      end

      it "should have at 2 pages" do
        @objects[:pages].should eq 2
      end

      it "should have at least 26 total items" do
        @objects[:total_count].should be >= 26
      end
    end



    context "with a specified page" do
      before :all do
        (pages1, @page1) = @acq.paginated_resource(@acq.objects_dataset)
        (pages2, @page2) = @acq.paginated_resource(@acq.objects_dataset, {'page' => 2})
      end

      it "should return 20 items" do
        @page2[:items].count.should eq 7
        @page2[:items_per_page].should eq 20
      end

      it "should return page 2" do
        @page2[:page].should eq 2
      end

      it "should have at least 2 pages" do
        @page2[:pages].should be >= 2
      end

      it "should have at least 26 total items" do
        @page2[:total_count].should be >= 26
      end

      it "should have all different items from page 1" do
        # Make lists of the id in each page
        items1 = @page1[:items].map{|o| o[:id]}
        items2 = @page2[:items].map{|o| o[:id]}

        # The intersection of the two should be empty
        (items1 & items2).should eq []
      end
    end

    context "with a specified number of items per page" do
      before :all do
        (pages, @objects) = @acq.paginated_resource(@acq.objects_dataset, {'per_page' => 5})
      end

      it "should return 5 items" do
        @objects[:items].count.should eq 5
        @objects[:items_per_page].should eq 5
      end

      it "should return page 1" do
        @objects[:page].should eq 1
      end

      it "should have at least 11 pages" do
        @objects[:pages].should be >= 4
      end

      it "should have at least 26 total items" do
        @objects[:total_count].should be >= 26
      end
    end

    context "with a specified page and number of items per page" do
      before :all do
        (pages1, @page1) = @acq.paginated_resource(@acq.objects_dataset, {'per_page' => 5})
        (pages2, @page2) = @acq.paginated_resource(@acq.objects_dataset, {'page' => 2, 'per_page' => 5})
      end

      it "should return 5 items" do
        @page2[:items].count.should eq 5
        @page2[:items_per_page].should eq 5
      end

      it "should return page 2" do
        @page2[:page].should eq 2
      end

      it "should have 6 pages" do
        @page2[:pages].should eq 6
      end

      it "should have at least 26 total items" do
        @page2[:total_count].should be >= 26
      end

      it "should have all different items from page 1" do
        # Make lists of the id in each page
        items1 = @page1[:items].map{|o| o[:id]}
        items2 = @page2[:items].map{|o| o[:id]}

        # The intersection of the two should be empty
        (items1 & items2).should eq []
      end
    end

    context "with strings passed as options" do      
      before :all do
        @options = {'page' => '2', 'per_page' => '5'}
      end

      it "should not raise an error" do
        expect { (pages, obj) = @acq.paginated_resource(@acq.objects_dataset, @options)}.
          to_not raise_error
      end
    end

    context "with bad strings passed as options" do
      it "should raise a BadParameterError" do
        # Options that cannot be converted into integers
        @options = {'page' => 'abc', 'per_page' => 'xyz'}
        expect {
          @acq.paginated_resource(@acq.objects_dataset, @options)
        }.to raise_error(MDL::BadParameterError)
      end
    end

    context "with no_objects" do
      before :all do
        (pages, @objects) = @acq.paginated_resource(@acq.objects_dataset, {'no_objects' => 1})
      end

      it "should have a count of objects" do
        @objects[:total_count].should be >= 26
      end

      it "should not have an array of items" do
        @objects[:items].should be_nil
      end
    end
  end
end

