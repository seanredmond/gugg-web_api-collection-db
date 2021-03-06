# -*- encoding: utf-8 -*-
require File.expand_path('../lib/gugg-web_api-collection-db/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Sean Redmond"]
  gem.email         = ["sredmond@guggenheim.org"]
  gem.description   = "Guggenheim collections API data"
  gem.summary       = "Classes for output of collections data for API"
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "gugg-web_api-collection-db"
  gem.require_paths = ["lib"]
  gem.version       = Gugg::WebApi::Collection::Db::VERSION

  gem.add_dependency "sequel"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "sqlite3"

end
