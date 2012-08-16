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

describe MDL::CollectionObject do
  before :all do
    @pwb = MDL::CollectionObject[1867]
  end

  describe "#titles" do
    it "should return a hash" do
      @pwb.titles.should be_an_instance_of Hash
    end

    it "should not have a sort title" do
    	puts @pwb.titles.inspect
    	# We used to include a sort title in the titles resource, but this is 
    	# redundant as the main object already has a sort_title property
    	@pwb.titles[:sort].should_not be
  	end
  end
end
