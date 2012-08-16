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
    @kandinsky = MDL::Constituent[1515]
  end

  it "should return rows" do
    # There are 4054 constituents as of Aug 2012
    MDL::Constituent.all().count.should be >= 4054
  end

  it "should have a last name" do
    @kandinsky.lastname.should eq "Kandinsky"
  end

  it "should have a first name" do
    @kandinsky.firstname.should eq "Vasily"
  end

  it "should have a middle name" do
    @kandinsky.middlename.should be_nil
  end

  it "should have a display name" do
    @kandinsky.displayname.should eq "Vasily Kandinsky"
  end

  it "should have a sort name" do
    @kandinsky.alphasort.should eq "Kandinsky, Vasily"
  end

  describe "#as_resource" do
    it "should return a Hash" do
      @kandinsky.as_resource.should be_an_instance_of Hash
    end
  end
end

describe MDL::ConstituentXref do
  before :all do
    @xref = MDL::ConstituentXref[1973]
  end

  it "should be a ConstituentXref" do
    @xref.should be_an_instance_of MDL::ConstituentXref
  end

  it "should be connected to a CollectionObject" do
    @xref.object.should be_an_instance_of MDL::CollectionObject
  end

  it "should be connected to a Constituent" do
    @xref.constituent.should be_an_instance_of MDL::Constituent
  end

  it "should be connected to a Role" do
    puts @xref.as_resource.inspect
    @xref.role.should be_an_instance_of MDL::Role
  end

end

