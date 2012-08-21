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

describe MDL::CollectionObject do
  before :all do
    @pwb = MDL::CollectionObject[1867]
  end

  it "should return rows" do
    # There are 977 objects as of Aug 2012
    MDL::CollectionObject.all().count.should be >= 977
  end

  it "should have sort fields" do
    @pwb.sort_fields.should be_an_instance_of(MDL::SortFields)
  end

  it "should have an object context" do
    @pwb.contexts.should be_an_instance_of(MDL::ObjectContext)
  end

  it "Should have the right accession number" do
    @pwb.objectnumber.should eq('37.245')
  end

  describe "#constituents" do
    it "should return an Array" do
      @pwb.constituents.should be_an_instance_of Array
    end

    it "should return an Array of ConstituentXref objects" do
      @pwb.constituents.each do |xref|
        xref.should be_an_instance_of MDL::ConstituentXref
      end
    end
  end

  describe '#copyright' do
    it "should have the right copyright" do
      @pwb.copyright.should eq(
        '© 2012 Artists Rights Society (ARS), New York/ADAGP, Paris'
      )
    end
  end

  describe '#essay' do
    it "should have an essay" do
      @pwb.essay.should start_with "<p>With its undulating colored ovals"
    end
  end

  describe '#is_highlight?' do
    it "'Painting with White Border' should be a highlight" do
      @pwb.is_highlight?.should be_true
    end

    it "'For an Anniversary' should not be a highlight" do
      MDL::CollectionObject[116].is_highlight?.should be_false
    end
  end

  describe '#is_recent_acquisition?' do
    it "'Painting With White Border' should not be a recent acquisition" do
      @pwb.is_recent_acquisition?.should be_false
    end
  end

  describe '#sort_title' do
    it "should have a sort title" do
      @pwb.sort_title.should be
    end
  end

  describe '#sort_name' do
    it "should have a sort name" do
      @pwb.sort_name.should be
    end
  end

  describe '#as_resource' do
    it "should be a hash" do
      @pwb.as_resource.should be_an_instance_of(Hash)
    end

    context "Painting with White Border" do
      before :all do
        @r = @pwb.as_resource
      end

      it "should have the accession number 37.245" do
        @r[:accession].should eq('37.245')
      end

      it "should have the right sort number" do
        @r[:sort_number].should eq('    37   245')
      end

      it "should have the right sort title" do
        @r[:sort_title].should eq('Painting with White Border')
      end

      it "should have the right sort name" do
        @r[:sort_name].should eq('Kandinsky, Vasily')
      end

      it "should be a highlight" do
        @r[:highlight].should be_true
      end

      it "should not be a recent acquisition" do
        @r[:recent_acquisition].should be_false
      end

      it "should have an essay" do
        @r[:essay].should start_with "<p>With its undulating colored ovals"
      end
    end

    context "For an Anniversary" do
      before :all do
        @r = MDL::CollectionObject[116].as_resource
      end

      it "should have the accession number 58.1530" do
        @r[:accession].should eq('58.1530')
      end

      it "should be a highlight" do
        @r[:highlight].should be_false
      end

      it "should not be a recent acquisition" do
        @r[:recent_acquisition].should be_false
      end

      it "should not have an essay" do
        @r[:essay].should be_nil
      end
    end
  end
end
