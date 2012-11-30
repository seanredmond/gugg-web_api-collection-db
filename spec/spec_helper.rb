require "rubygems"
require "sequel"
require "sqlite3"
require "yaml"

cfg = YAML.load_file('collection_db_spec.yml')
# db = cfg['db']['mysql']
# @DB = Sequel.mysql(db['db'], :user=>db['user'], :password=>db['password'], 
#   :host=>db['host'], :charset=>'utf8')
# @DB = Sequel.connect('sqlite://apitest.db');
@DB = Sequel.sqlite(cfg['test']['db']);

# Set up exhibitions, one past, one current, one future
today = Date.today
pastex = @DB[:collection_tms_exhibitions].where(:exhibitionid => 1)
currentex = @DB[:collection_tms_exhibitions].where(:exhibitionid => 2)
futureex = @DB[:collection_tms_exhibitions].where(:exhibitionid => 3)

pastex.update(:beginisodate => today - 365, :endisodate => today - 360)
currentex.update(:beginisodate => today - 30, :endisodate => today + 30)
futureex.update(:beginisodate => today + 305, :endisodate => today + 365)

require 'gugg-web_api-collection-db'

MDL = Gugg::WebApi::Collection::Db
LNK = Gugg::WebApi::Collection::Linkable

LNK::root = "http://u.r.i/collection"
LNK::map_path(
  MDL::CollectionObject, 'objects'
)
LNK::map_path(
  MDL::ObjectType, 'objects/types'
)


MDL::Media::media_root = "http://emuseum2.guggenheim.org/media"
MDL::Media::media_paths = {
	:full => 'full',
	:large => 'large',
	:medium => 'previews',
	:small => 'thumbnails',
	:tiny => 'postagestamps'
}
MDL::Media::media_dimensions = {
	:large => 490,
	:medium => 300,
	:small => 160,
	:tiny => 62
}
