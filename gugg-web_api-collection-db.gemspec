# -*- encoding: utf-8 -*-
require File.expand_path('../lib/gugg-web_api-collection-db/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Sean Redmond"]
  gem.email         = ["github-smr@sneakemail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "gugg-web_api-collection-db"
  gem.require_paths = ["lib"]
  gem.version       = Gugg::WebApi::Collection::Db::VERSION
end
