# Gugg::WebApi::Collection::Db

Guggenheim Collections API database interface. This library is intended to 
serve as the data query layer for the Guggenheim Collections API. 

For more details, see the {file:overview.md Overview}

## Installation

Add this line to your application's Gemfile:

    gem 'gugg-web_api-collection-db'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gugg-web_api-collection-db

## Usage

    require "gugg-web_api-collection-db"

    Gugg::WebApi::Collection::Db::CollectionObject[1867].as_resource()

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
