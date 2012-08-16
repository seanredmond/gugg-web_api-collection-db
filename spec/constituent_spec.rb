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

describe MDL::Constituent do
  before :all do
    @kandinsky = Constituent[1515]
  end

  it "should return rows" do
    # There are 4054 constituents as of Aug 2012
    MDL::Constituent.all().count.should be >= 4054
  end

  it "should have a last name" do
    @kandinsky.last_name.should eq "Kandinksy"
  end

  it "should have a first name" do
    @kandinsky.first_name.should eq "Vasily"
  end

  it "should have a middle name" do
    @kandinsky.middle_name.should be_nil
  end

  it "should have a display name" do
    @kandinsky.middle_name.should eq "Vasily Kandinsky"
  end

  it "should have a sort name" do
    @kandinsky.alphasort.should eq "Kandinsky, Vasily"
  end

end
