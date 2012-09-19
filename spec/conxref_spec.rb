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

describe MDL::ConstituentXref do
  context "gutai" do
    before :all do 
      @xref = MDL::ConstituentXref[123506]
      @c = MDL::Constituent[11240]
    end

    it "should work" do
      @xref.should be_an_instance_of MDL::ConstituentXref
      @c.should be_an_instance_of MDL::Constituent
    end

    it "should have a non-nil constituent" do
      @xref.constituent.should_not be_nil
    end
  end


end

