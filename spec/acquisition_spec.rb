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

describe MDL::Acquisition do
  it "should return rows" do
    # There are 12 acquisitions as of Aug 2012
    MDL::Acquisition.all().count.should be >= 12
  end

  describe ".List" do
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

    it "has CollectionObject objects" do
      @acq[:acquisitions].each do |a|
        a[:objects].should be_an_instance_of Array
        a[:objects].count.should be > 0
      end
    end

  end
end
