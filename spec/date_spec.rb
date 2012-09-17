# Tests for date resources
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

describe "MDL.date_resource" do
  it "should return a Hash" do
    MDL.date_resource(1900, 1910, "1900-1910").should be_an_instance_of Hash
  end

  it "should convert 0 dates to nil" do
    d = MDL.date_resource(1900, 0, "1900-1910")
    d[:end].should be_nil
  end
end
