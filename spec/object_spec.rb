# Tests for tables without any extra implementation beyond Sequel
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

require 'spec_helper'

Gugg::WebApi::Collection::Linkable::root = "http://u.r.i/collection"
Gugg::WebApi::Collection::Linkable::map_path(
  Gugg::WebApi::Collection::Db::CollectionObject, 'objects'
)

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

  describe "#acquisition" do
    it "should return an Acquisition" do
      @pwb.acquisition.should be_an_instance_of MDL::Acquisition
    end

    it "should be Expressionism" do
      @pwb.acquisition.acquisition.
        should eq "Solomon R. Guggenheim Founding Collection"
    end
  end

  describe "#movements" do 
    it "should return an Array" do
      @pwb.movements.should be_an_instance_of Array
    end

    it "should have 1 item" do
      @pwb.movements.count.should eq 1
    end

    it "should be Expressionism" do
      @pwb.movements.first.name.should eq "Expressionism"
    end
  end

  describe "#sites" do
    it "should return an Array" do
      @pwb.sites.should be_an_instance_of Array
    end

    it "should have 1 item" do
      @pwb.sites.count.should eq 1
    end

    it "should be Expressionism" do
      @pwb.sites.first.name.should eq "Solomon R. Guggenheim Museum"
    end
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

  describe '#is_collection?' do
    it "'Painting with White Border' should be in Collection Online" do
      @pwb.is_collection?.should be_true
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

  describe '#location' do
    it 'returns a Location' do
      MDL::SortFields[3417].objlocation.should be_an_instance_of MDL::Location
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

      it "should have movements" do
        @r[:movements].should be_an_instance_of Array
      end

      it "should have sites" do
        @r[:sites].should be_an_instance_of Array
      end

      it "should have an acquisition" do
        @r[:acquisition][:name].
          should eq 'Solomon R. Guggenheim Founding Collection'
      end

      it "should have a web link" do
        @r[:_links][:web][:href].should include(@r[:accession])
      end

      it "should have a location" do
        @r.keys().include?(:location).should be_true
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

      it "should have no movements" do
        @r[:movements].should be_nil
      end

      it "should have not have an acquisition" do
        @r[:acquisition].should be_nil
      end
    end

    context "Gaugin, In the Vanilla Grove" do
      before :all do
        @r = MDL::CollectionObject[1413].as_resource
      end

      it "should have 3 movements" do
        @r[:movements].count.should eq 3
      end

      it "should be classed Primitivism, Post-Impressionism & Symbolism" do
        movements = @r[:movements].map{|m| m[:name]}
        movements.sort.should eq ['Post-Impressionism', 'Primitivism', 'Symbolism']
      end
    end

    context "Picasso, Woman Ironing" do
      before :all do
        @r = MDL::CollectionObject[3417].as_resource
      end

      it "should be in Picasso B&W" do
        @r[:exhibitions].map{|e| e[:name] }.should 
          include('Picasso Black and White')
      end

      it "has a location resource" do
        @r[:location].should be_an_instance_of Hash
        @r[:location][:area].should eq 'Ramp 1'
      end
    end

    context "Load for Gutai" do
      before :all do
        @r = MDL::CollectionObject[25905].as_resource
      end

      it "should be in GUTAI" do
        @r[:exhibitions].map{|e| e[:name] }.should 
          include('GUTAI')
      end

      it "should not have a link to Collection Online" do
        @r[:_links][:web].should_not be
      end
    end
  end

  describe '#on_view' do
    context "with defaults" do
      before :all do
        @on_view = MDL::CollectionObject.on_view({:add_to_path => 'on-view'})
      end

      it "should return a hash" do
        @on_view.should be_an_instance_of Hash
      end

      it "should have _links" do
        @on_view[:_links].should be_an_instance_of Hash
      end

      it "should link to itself" do
        @on_view[:_links][:_self][:href].
          should start_with "http://u.r.i/collection/objects/on-view"
        @on_view[:_links][:next][:href].
          should start_with "http://u.r.i/collection/objects/on-view"
      end
    end

    context "with options" do
      before :all do
        @on_view = MDL::CollectionObject.on_view(
          {"page" => 2, "per_page" => 5, :add_to_path => 'on-view'})
      end

      it "should return the second page"  do
        @on_view[:objects][:page].should eq 2
      end

      it "should have five objects per page" do
        @on_view[:objects][:items_per_page].should eq 5
      end
    end
  end
end
