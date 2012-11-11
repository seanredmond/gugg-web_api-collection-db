require "rubygems"
require "sequel"
require "yaml"

cfg = YAML.load_file('collection_db_spec.yml')
db = cfg['db']['mysql']
@DB = Sequel.mysql(db['db'], :user=>db['user'], :password=>db['password'], 
  :host=>db['host'], :charset=>'utf8')

require 'gugg-web_api-collection-db'

MDL = Gugg::WebApi::Collection::Db

MDL::Media::media_root = "http://emuseum2.guggenheim.org/media"
MDL::Media::media_paths = {
	'full' => 'full',
	'large' => 'large',
	'medium' => 'previews',
	'thumbnail' => 'thumbnails',
	'tiny' => 'postagestamps'
}
MDL::Media::media_dimensions = {
	'large' => 409,
	'medium' => 300,
	'thumbnail' => 160,
	'tiny' => 62
}
