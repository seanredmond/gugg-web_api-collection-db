# Tests for odd and unique cases in the data
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

# More than on site: You would expect each object to belong to one site (that 
# is, one museum affiliate). One piece, however, Robert Rauschenberg's "Barge"
# belongs to both SRGM in New York and Guggenheim Bilbao
describe "Rauschenberg's 'Barges'" do
  before :all do
    @barges = MDL::CollectionObject[3547]
  end

  it "should have two sites" do
    @barges.sites.count.should eq 2
  end
end
