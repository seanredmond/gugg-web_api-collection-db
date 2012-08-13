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

describe MDL::LanguageCode do
  it "should return rows" do
    # There are 12 language codes as of Aug 2012
    MDL::LanguageCode.all().count.should be >= 12
  end

  it "should contain expected values" do
    MDL::LanguageCode[1].language_code.should eq('en')
  end
end

describe MDL::MediaType do
  it "should return rows" do
    # There are 9 media types as of Aug 2012
    MDL::MediaType.all().count.should be >= 9
  end

  it "should contain expected values" do
    MDL::MediaType[1].mediatype.should eq('Image')
  end
end

describe MDL::ObjectContext do
  it "should return rows" do
    # There are 977 object contexts as of Aug 2012
    MDL::ObjectContext.all().count.should be >= 977
  end

  it "should contain expected fields" do
    context = MDL::ObjectContext.first
    context.longtext7.should be
    context.flag5.should be
    context.flag6.should be
  end
end

describe MDL::TextEntry do
  it "should return rows" do
    # There are 346 text entries as of Aug 2012
    MDL::TextEntry.all().count.should be >= 346
  end

  it "should contain expected values" do
    (MDL::TextEntry[17041].textentry =~ /Marina Abramovi&#263;/).should be_true
  end
end

describe MDL::TitleType do
  it "should return rows" do
    # There are 13 title types as of Aug 2012
    MDL::TitleType.all().count.should be >= 13
  end

  it "should contain expected values" do
    MDL::TitleType[3].titletype.should eq('Original Title')
  end
end

