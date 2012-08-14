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

describe MDL::MediaFormat do
  it "should return rows" do
    # There are 24 media formats as of Aug 2012
    MDL::MediaFormat.all().count.should be >= 24
  end

  it "should contain expected values" do
    MDL::MediaFormat[2].format.should eq('JPEG')
  end

  it "should be able to retrieve associated language code" do
    MDL::MediaFormat[2].type.mediatype.should eq('Image')
  end
end
