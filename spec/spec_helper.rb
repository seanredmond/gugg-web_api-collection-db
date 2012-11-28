require "rubygems"
require "sequel"
require "yaml"

cfg = YAML.load_file('collection_db_spec.yml')
db = cfg['db']['mysql']
@DB = Sequel.mysql(db['db'], :user=>db['user'], :password=>db['password'], 
  :host=>db['host'], :charset=>'utf8')

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
