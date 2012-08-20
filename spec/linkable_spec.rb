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

describe Gugg::WebApi::Collection do
  before :all do
    Gugg::WebApi::Collection::Linkable::root = "http://u.r.i/collection"
    Gugg::WebApi::Collection::Linkable::map_path(
      Gugg::WebApi::Collection::Db::CollectionObject, 'objects'
    )
    @pwb = MDL::CollectionObject[1867]

  end

  it "returns a link" do
    @pwb.self_link[:_self][:href].should eq 'http://u.r.i/collection/objects/1867'
  end
end

