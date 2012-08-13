require "rubygems"
require "sequel"
require "yaml"

cfg = YAML.load_file('collection_db_spec.yml')
db = cfg['db']['mysql']
@DB = Sequel.mysql(db['db'], :user=>db['user'], :password=>db['password'], 
  :host=>db['host'], :charset=>'utf8')

require 'gugg-web_api-collection-db'

MDL = Gugg::WebApi::Collection::Db

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

