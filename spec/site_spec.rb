# Tests for sites
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

describe MDL::Site do
  it "should return rows" do
    # There are 4 sites as of Sep 2012
    MDL::Site.all().count.should be >= 4
  end

  it "should contain expected values" do
    MDL::Site[3].sitename.should eq('Solomon R. Guggenheim Museum')
  end

  it "should not contain Historical Images (#21)" do
    MDL::Site[21].should be_nil
  end

  describe "#as_resource" do
    context "with defaults" do
      before :all do
        @site = MDL::Site[3].as_resource
      end

      it "should return a hash" do
        @site.should be_an_instance_of Hash
      end

      it "should contain links" do
        @site[:_links].should be
      end

      it "should link to the next page" do
        @site[:_links][:next][:href].should include "page=2"
      end

      it "should contain objects" do
        @site[:objects].should be_an_instance_of Hash
      end

      it "should contain pages of objects" do
        @site[:objects][:items].count.should eq 20
        @site[:objects][:total_count].should be >= 823
      end
    end
  end

  describe ".list" do
    context "with defaults" do
      before :all do
        @site = MDL::Site.list
      end

      it "should return a Hash" do
        @site.should be_an_instance_of Hash
      end

      it "has a list of Site resources" do
        @site[:sites].each do |s|
          s.should be_an_instance_of Hash
          s[:id].should be
          s[:name].should be
        end
      end

      it "should have Site resources with 5 items" do
        @site[:sites].each do |s|
          s[:objects][:items].should have_at_least(1).items
          s[:objects][:items].should have_at_most(5).items
        end
      end
    end
  end
end
