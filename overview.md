# Overview

## Organization of the Library

Gugg::WebApi::Collection::Db is the data query layer for the Guggenheim 
Collections API. Most classes, like CollectionObject and Constituent, map to 
resources available through the API's endpoints, like 
`http://api.guggenheim.org/collections/objects` and 
`http://api.guggenheim.org/collections/constituents`

This library relies heavily on the  [Sequel database
toolkit](http://sequel.rubyforge.org/) and most classes extend `Sequel::Model`.
The simplest possible example would be a class like
{Gugg::WebApi::Collection::Db::TitleType} which simply maps the class to a
database table and has no  functionality beyond what is provided by
`Sequel::Model`:

{include:file:lib/gugg-web_api-collection-db/title_type.rb}

A class like `TitleType` is not a resource that can be retrieved by itself via
the API. Classes that represent top-level API resources all have an
`as_resource`  instance method like
{Gugg::WebApi::Collection::Db::CollectionObject#as_resource}  and/or a `list`
class method like {Gugg::WebApi::Collection::Db::Exhibition.list}. `list` and
other similar class methods will all return arrays of objects of the given
class. `as_resource` methods all return Hash representations of the objects,
ready to be serialized in JSON. Classes corresponding to these top-level
resources are:

* {Gugg::WebApi::Collection::Db::Acquisition}
* {Gugg::WebApi::Collection::Db::CollectionObject}
* {Gugg::WebApi::Collection::Db::Constituent}
* {Gugg::WebApi::Collection::Db::Exhibition}
* {Gugg::WebApi::Collection::Db::Movement}
* {Gugg::WebApi::Collection::Db::ObjectType}
* {Gugg::WebApi::Collection::Db::Site}

In between these top-level resources and classes like
{Gugg::WebApi::Collection::Db::TitleType} are classes that have an `as_resource`
method so that their Hash representations can be included in the Hash
representations of their parent objects. For instance a
{Gugg::WebApi::Collection::Db::CollectionObject} resource includes a
{Gugg::WebApi::Collection::Db::ObjectTitle} resource (which includes a
{Gugg::WebApi::Collection::Db::TitleType} and so on until you've gone down
through all the turtles).

## Mixins: Linkable, Collectible, and Dateable

### Linkable, or What's my URL?

All resources need to be able to generate links to themselves, and this is
provided throught the {Gugg::WebApi::Collection::Linkable} module.


### Collectible, for things that contain other things

All of the top-level resources except for
{Gugg::WebApi::Collection::Db::CollectionObject} represent things that contain a
number of {Gugg::WebApi::Collection::Db::CollectionObject} objects - the objects
in an exhibition for instance. These classes all include the
{Gugg::WebApi::Collection::Collectible} module.

The main feature of this module is the
{Gugg::WebApi::Collection::Collectible#paginated_resource} method which takes a
[Sequel paginated dataset](http://sequel.rubyforge.org/rdoc-
plugins/classes/Sequel/Dataset/Pagination.html) and turns it into a Paginated
Objects resource as outlined in the API documentation.

Many of the query parameters of API endpoints are passed on to
{Gugg::WebApi::Collection::Collectible#paginated_resource} in this method's
`option` parameter -- in particular, `per_page` which controls the number of
objects per page and `page` which requests a particular page from the paginated
set.

### Dateable, because all good things must come to an end

Compared to the previous two mixins, {Gugg::WebApi::Collection::Dateable} is
fairly trivial. It simply provides a consistent way to generate date resources
for the API ({Gugg::WebApi::Collection::Dateable#date_resource})

## Configuration

Besides needing a database connection (set up via Sequel) the libray needs a few variables to be set in order to operate properly.

### For Linkable

The Linkable module needs a `root` and a mapping between classes and enpoints. First set the root:

    Gugg::WebApi::Collection::Linkable::root = "http://api.guggenheim.org/collections"

Then set up the mappings between each class that corresponds to an endoint and the URL of the endpoint (relative to the `root`) with {Gugg::WebApi::Collection::Linkable#map_path}

    Gugg::WebApi::Collection::Linkable::map_path(
      Gugg::WebApi::Collection::Db::Exhibition, 'exhibitions'
    )
    Gugg::WebApi::Collection::Linkable::map_path(
      Gugg::WebApi::Collection::Db::CollectionObject, 'objects'
    )
    Gugg::WebApi::Collection::Linkable::map_path(
      Gugg::WebApi::Collection::Db::ObjectType, 'objects/types'
    )

These mappings are used when objects generate their links. For instance, with
the commands above, when a {Gugg::WebApi::Collection::Db::Exhibition} instance
with the id 100 calls {Gugg::WebApi::Collection::Linkable#self_link}, the result
will be a concatentation of the root, the mapped path and the id:
`http://api.guggenheim.org/collections/exhibitions/100`.

### For media

{Gugg::WebApi::Collection::Db::Media} objects need to generate URLs as well,
but because these point to locations outside the API they are handled
differently. The root url for all collection related media needs to be set in
{Gugg::WebApi::Collection::Db::Media.media_root}, then Hashes need to be given
which map particular sizes to paths relative to the root, and maximum dimensions
of each available size:

    Gugg::WebApi::Collection::Db::Media::media_paths = {
        :full => 'full',
        :large => 'large',
        :medium => 'previews',
        :small => 'thumbnails',
        :tiny => 'postagestamps'
    }
    Gugg::WebApi::Collection::Db::Media::media_dimensions = {
        :large => 490,
        :medium => 300,
        :small => 160,
        :tiny => 62
    }

Because there is no `:full` member in `media_dimensions` there is no maximum size.

See {file:spec/spec_helper.rb} for examples




