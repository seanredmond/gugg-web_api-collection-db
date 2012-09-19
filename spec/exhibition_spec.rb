# Tests for Exhibitions
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

describe MDL::Exhibition do
  before :all do
    @gutai = MDL::Exhibition[4886]
  end

  it "should return rows" do
    # There are 2 acquisitions as of Sept 2012
    MDL::Exhibition.all().count.should be >= 2
  end

  it "should have objects" do
    # 160 objects in Gutai as of Sept 2012
    @gutai.objects.count.should be_within(5).of(160)
  end

  it "should have Guggenheim objects" do
    @gutai.ours.count.should be <= @gutai.objects.count
  end

  it "should have non Guggenheim objects" do
    @gutai.not_ours.count.should be <= @gutai.objects.count
  end

  describe "#name" do
    it "should have a name" do
      @gutai.name.should eq "GUTAI"
    end
  end

  describe "#as_resource" do
    it "should work" do
      @gutai.should be_an_instance_of MDL::Exhibition
    end

    context "with defaults" do
      before :all do 
        @res = MDL::Exhibition[4886].as_resource
      end

      it "should return a Hash" do
        @res.should be_an_instance_of Hash
      end

      it "should have objects" do
        @res[:objects].should be_an_instance_of Hash
      end
    end
  end
end
