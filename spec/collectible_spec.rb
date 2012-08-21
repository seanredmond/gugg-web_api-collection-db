# Tests for tables without any extra implementation beyond Sequel
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

require "rubygems"
require "sequel"
require "yaml"

cfg = YAML.load_file('collection_db_spec.yml')
db = cfg['db']['mysql']
@DB = Sequel.mysql(db['db'], :user=>db['user'], :password=>db['password'], 
  :host=>db['host'], :charset=>'utf8')

require 'gugg-web_api-collection-db'

MDL = Gugg::WebApi::Collection::Db

describe Gugg::WebApi::Collection::Collectible do
  before :all do
    # Solomon R. Guggenheim Collection
    @acq = MDL::Acquisition[6]
  end

  describe "#paginated_resource" do
    context "with defaults" do
      before :all do 
        @objects = @acq.paginated_resource
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

      it "should have at least 3 pages" do
        @objects[:pages].should be >= 3
      end

      it "should have at least 55 total items" do
        @objects[:total_count].should be >= 55
      end
    end

    context "with a specified page" do
      before :all do
        @page1 = @acq.paginated_resource
        @page2 = @acq.paginated_resource({:page => 2})
      end

      it "should return 20 items" do
        @page2[:items].count.should eq 20
        @page2[:items_per_page].should eq 20
      end

      it "should return page 2" do
        @page2[:page].should eq 2
      end

      it "should have at least 3 pages" do
        @page2[:pages].should be >= 3
      end

      it "should have at least 55 total items" do
        @page2[:total_count].should be >= 55
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
        @objects = @acq.paginated_resource({:per_page => 5})
      end

      it "should return 5 items" do
        @objects[:items].count.should eq 5
        @objects[:items_per_page].should eq 5
      end

      it "should return page 1" do
        @objects[:page].should eq 1
      end

      it "should have at least 11 pages" do
        @objects[:pages].should be >= 11
      end

      it "should have at least 55 total items" do
        @objects[:total_count].should be >= 55
      end
    end

    context "with a specified page and number of items per page" do
      before :all do
        @page1 = @acq.paginated_resource({:per_page => 5})
        @page2 = @acq.paginated_resource({:page => 2, :per_page => 5})
      end

      it "should return 5 items" do
        @page2[:items].count.should eq 5
        @page2[:items_per_page].should eq 5
      end

      it "should return page 2" do
        @page2[:page].should eq 2
      end

      it "should have at least 11 pages" do
        @page2[:pages].should be >= 11
      end

      it "should have at least 55 total items" do
        @page2[:total_count].should be >= 55
      end

      it "should have all different items from page 1" do
        # Make lists of the id in each page
        items1 = @page1[:items].map{|o| o[:id]}
        items2 = @page2[:items].map{|o| o[:id]}

        # The intersection of the two should be empty
        (items1 & items2).should eq []
      end
    end
  end
end

