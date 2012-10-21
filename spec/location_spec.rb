# Tests for Location class
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

describe MDL::Location do
  it "return rows" do
    # There are 54 locations as of Oct 2012
    MDL::Location.all().count.should be >= 54
  end

  context "with a known location" do
    before :all do
      @loc = MDL::Location[2]
    end

    it "has an area" do
      @loc.area.should eq 'Ramp 1'
    end

    it 'has a location' do
      @loc.location.should eq 'Bay 11'
    end

    it 'has a related Site' do
      @loc.site.should be_an_instance_od MDL::Site
    end

  end
end
