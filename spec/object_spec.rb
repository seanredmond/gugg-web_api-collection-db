# encoding: utf-8
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
    @has_no_essay = MDL::CollectionObject[784]
  end

  it "should return rows" do
    MDL::CollectionObject.all().count.should be >= 46
  end

  # it "should have sort fields" do
  #   @pwb.sort_fields.should be_an_instance_of(MDL::SortFields)
  # end

  it "should have an object context" do
    @pwb.contexts.should be_an_instance_of(MDL::ObjectContext)
  end

  it "Should have the right accession number" do
    @pwb.objectnumber.should eq('37.245')
  end

  describe "#acquisition" do
    it "returns an Acquisition" do
      @pwb.acquisition.should be_an_instance_of MDL::Acquisition
    end

    it "returns the right Acquisition" do
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
    context 'an object with an essay' do
      it "returns an essay" do
        @pwb.essay.should start_with "<p>With its undulating colored ovals"
      end
    end

    context 'an object without an essay' do
      it 'returns nil' do
        @has_no_essay.essay.should be_nil
      end
    end
  end

  describe '#has_essay' do
    context 'an object with an essay' do
      it 'says it has an essay' do
        @pwb.has_essay?.should be_true
      end
    end

    context 'an object without an essay' do
      it 'says it has no essay' do
        @has_no_essay.has_essay?.should be_false
      end
    end
  end

  describe '#is_collection?' do
    it "'Painting with White Border' should be in Collection Online" do
      @pwb.is_collection?.should be_true
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

  describe '#current_location' do
    it 'returns a Location' do
      @pwb.current_location.should be_an_instance_of MDL::Location
    end
  end

  describe '#permanent_collection' do
    context 'an object in the permanent collection' do
      it 'is true' do
        @pwb.permanent_collection?.should be_true
      end
    end

    context 'a loaned object' do
      it 'is false' do
        MDL::CollectionObject[28666].permanent_collection?.should be_false
      end
    end
  end

  describe '#object_type' do
    it 'is an array' do
      @pwb.object_types.should be_an_instance_of Array
    end

    it 'contains ObjectType objects' do
      @pwb.object_types.first.should be_an_instance_of MDL::ObjectType
    end

    it 'is the right type' do
      @pwb.object_types.first.name.should eq 'Painting'
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

      it "should say whether or not it's a recent acquisition" do
        @r[:recent_acquisition].should_not be_nil
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
        @r.keys().include?(:current_location).should be_true
      end

      it "has media" do
        @r.keys().include?(:media).should be_true
        @r[:media].should be_an_instance_of Array
      end

      it 'has object types' do
        @r[:object_types].should be_an_instance_of Array
      end

      it 'has constituents' do
        @r[:constituents].should be_an_instance_of Array
      end

      it 'has at least one constituent' do
        @r[:constituents][0].should be_an_instance_of Hash
      end

      it 'has a constituent with no bio' do
        @r[:constituents][0][:constituent][:bio].should be_nil
      end

      it 'has a constituent that says it has a bio if you ask' do
        @r[:constituents][0][:constituent][:has_bio].should be_true
      end
    end

    context "with no_essays" do
      before :all do  
        @pwb_no_essay = @pwb.as_resource({'no_essay' => 'true'})
        @has_no_essay_really = 
          @has_no_essay.as_resource({'no_essay' => 'true'})
      end

      context 'an object with an essay' do
        it "has no essay" do
          @pwb_no_essay.keys.include?(:essay).should be_false
        end

        it "says it has an essay" do
          @pwb_no_essay[:has_essay].should be_true
        end
      end

      context 'an object without an essay' do
        it "has no essay" do
          @has_no_essay_really.keys.include?(:essay).should be_false
        end

        it "says it has an essay" do
          @has_no_essay_really[:has_essay].should be_false
        end
      end
    end

    # context "For an Anniversary" do
    #   before :all do
    #     @r = MDL::CollectionObject[116].as_resource
    #   end

    #   it "should have the accession number 58.1530" do
    #     @r[:accession].should eq('58.1530')
    #   end

    #   it "should be a highlight" do
    #     @r[:highlight].should be_false
    #   end

    #   it "should not be a recent acquisition" do
    #     @r[:recent_acquisition].should be_false
    #   end

    #   it "should not have an essay" do
    #     @r[:essay].should be_nil
    #   end

    #   it "should have no movements" do
    #     @r[:movements].should be_nil
    #   end

    #   it "should have not have an acquisition" do
    #     @r[:acquisition].should be_nil
    #   end
    # end

    # context "Gaugin, In the Vanilla Grove" do
    #   before :all do
    #     @r = MDL::CollectionObject[1413].as_resource
    #   end

    #   it "should have 3 movements" do
    #     @r[:movements].count.should eq 3
    #   end

    #   it "should be classed Primitivism, Post-Impressionism & Symbolism" do
    #     movements = @r[:movements].map{|m| m[:name]}
    #     movements.sort.should eq ['Post-Impressionism', 'Primitivism', 'Symbolism']
    #   end
    # end

    # context "Picasso, Woman Ironing" do
    #   before :all do
    #     @r = MDL::CollectionObject[3417].as_resource
    #   end

    #   it "should be in Picasso B&W" do
    #     @r[:exhibitions].map{|e| e[:name] }.should 
    #       include('Picasso Black and White')
    #   end

    #   it "has a location resource" do
    #     @r[:location].should be_an_instance_of Hash
    #     @r[:location][:area].should eq 'Ramp 1'
    #   end
    # end

    # context "Load for Gutai" do
    #   before :all do
    #     @r = MDL::CollectionObject[25905].as_resource
    #   end

    #   it "should be in GUTAI" do
    #     @r[:exhibitions].map{|e| e[:name] }.should 
    #       include('GUTAI')
    #   end

    #   it "should not have a link to Collection Online" do
    #     @r[:_links][:web].should_not be
    #   end
    # end
  end

  context "an object on view" do
    it 'has a location' do
      @pwb.current_location.should be_an_instance_of MDL::Location
    end

    it 'includes its location in its resource' do
      @pwb.as_resource[:current_location][:location].should eq "Rotunda Level 2"
    end

    context "exhibitions" do
      it "has a list of exhibition" do
        @pwb.as_resource[:exhibitions].should be_an_instance_of Array
      end

      it "has exhibition items that are Hashes" do
        @pwb.as_resource[:exhibitions][0].should be_an_instance_of Hash
      end

      it "has exhibition items consisting of Location and an Exhibition" do
        @pwb.as_resource[:exhibitions][0][:location].
          should be_an_instance_of Hash
        @pwb.as_resource[:exhibitions][0][:exhibition].
          should be_an_instance_of Hash
      end
    end
  end

  context "an object not on view" do
    before :all do 
      @in_storage = MDL::CollectionObject[671]
    end

    it 'has no location' do
      @in_storage.current_location.should be_nil
    end

    it 'has no location in its resource' do
      @in_storage.as_resource[:location].should be_nil
    end

    it 'still has the key :location in its resource' do
      @in_storage.as_resource.keys.include?(:current_location).should be_true
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

      it "returns 2 objects" do
        @on_view[:objects][:items].count.should eq 2
      end

      it "should have _links" do
        @on_view[:_links].should be_an_instance_of Hash
      end

      it 'returns objects with essays' do
        @on_view[:objects][:items].first.keys.include?(:essay).should be_true
      end

      it "should link to itself" do
        @on_view[:_links][:_self][:href].
          should start_with "http://u.r.i/collection/objects/on-view"
      end
    end

    context "with collection = all" do
      it "returns 3 objects" do
        @on_view = MDL::CollectionObject.on_view({:add_to_path => 'on-view', 'collection' => 'all'})

        @on_view[:objects][:items].count.should eq 3
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

    context 'with no_essay = true' do
      before :all do
        @on_view = MDL::CollectionObject.on_view(
          {"no_essay" => 'true', :add_to_path => 'on-view'})
      end

      it 'returns objects without essays' do
        @on_view[:objects][:items].first.keys.include?(:essay).should be_false
      end
    end
  end

  describe ".years" do
    before :all do
      @years = MDL::CollectionObject.years({:add_to_path => 'dates'})
    end

    it "returns a Hash that contains an Array of Hashes" do
      @years.should be_an_instance_of Hash
      @years[:dates].should be_an_instance_of Array
      @years[:dates].first.should be_an_instance_of Hash
    end

    it "returns counts" do
      @years[:dates].first[:objects][:total_count].should be > 0
    end
  end

  describe ".decades" do
    before :all do
      @years = MDL::CollectionObject.decades({:add_to_path => 'dates/decades'})
    end

    it "returns a Hash with _links with a decades property" do
      @years.should be_an_instance_of Hash
      @years[:_links].should be_an_instance_of Hash
      @years[:_links][:decades].should be_an_instance_of Array
    end
  end

  describe ".by_year" do
    before :all do
      @by_year = MDL::CollectionObject.by_year(1923, {:add_to_path => 'dates'})
    end

    it "returns a Hash" do
      @by_year.should be_an_instance_of Hash
    end

    it "Only has objects created in or around 1923" do
      @by_year[:objects][:items].each do |o|
        1923.should be >= o[:dates][:begin]
        1923.should be <= o[:dates][:end]
      end
    end

    it "returns urls that end with the year" do
      @by_year[:_links][:_self][:href].should end_with('1923')
    end

    it 'returns objects with essays' do
      @by_year[:objects][:items].first.keys.include?(:essay).should be_true
    end

    # There are five objects in the test data created in 1956, both loans. 
    context 'without collection = all' do
      it 'does not return loaned objects' do
        @objects = MDL::CollectionObject.by_year(1956, 
          {:add_to_path => 'dates'})
        @objects[:objects][:items].should be_nil
      end
    end

    context 'with collection = all' do
      it 'returns loaned objects' do
        @objects = MDL::CollectionObject.by_year(1956, 
          {:add_to_path => 'dates', 'collection' => 'all'})
        @objects[:objects][:items].count.should eq 5
      end
    end

    context 'with no_essay = true' do
      before :all do 
        @no_essays = MDL::CollectionObject.
          by_year(1923, {'no_essay' => 'true', :add_to_path => 'dates'})
      end

      it 'returns objects without essays' do
        @no_essays[:objects][:items].first.keys.include?(:essay).should be_false
      end
    end

    context "bad requests" do
      it "should raise an error if the year isn't an integer" do
        expect {
          MDL::CollectionObject.by_year('Nineteen-twenty-three')
        }.to raise_error(MDL::BadParameterError)
      end
    end
  end

  describe ".by_year_range" do
    before :all do
      @by_year = MDL::CollectionObject.by_year_range(1923, 1933, {:add_to_path => 'dates'})
    end

    it "returns a Hash" do
      @by_year.should be_an_instance_of Hash
    end

    it "returns urls that end with the years" do
      @by_year[:_links][:_self][:href].should end_with('1923/1933')
    end

    # There are five objects in the test data created in 1956, both loans. 
    context 'without collection = all' do
      it 'does not return loaned objects' do
        @objects = MDL::CollectionObject.by_year_range(1950, 1959,
          {:add_to_path => 'dates'})
        @objects[:objects][:items].count.should eq 3
      end
    end

    context 'with collection = all' do
      it 'returns loaned objects' do
        @objects = MDL::CollectionObject.by_year_range(1950, 1959,
          {:add_to_path => 'dates', 'collection' => 'all'})
        @objects[:objects][:items].count.should eq 9
      end
    end

    context "bad requests" do
      it "should raise an error if one of the years isn't an integer" do
        expect {
          MDL::CollectionObject.by_year('Nineteen-twenty-three', 1905)
        }.to raise_error(MDL::BadParameterError)
      end

      it "should raise an error if the start year isn't less than the end year" do
        expect {
          MDL::CollectionObject.by_year_range(1923, 1905)
        }.to raise_error(MDL::BadParameterError)
      end
    end
  end

  describe ".list" do
    before :each do 
      @objects =  MDL::CollectionObject.list()
    end

    it "returns a Hash" do
      @objects.should be_an_instance_of Hash
    end

    it "returns enough objects" do
      @objects[:objects][:total_count].should eq 52
    end

    it 'returns objects with essays' do
      @objects[:objects][:items].first.keys.include?(:essay).should be_true
    end

    context 'with no_essay = true' do
      before :all do
        @no_essays = MDL::CollectionObject.list({'no_essay' => 'true'})
      end

      it 'returns objects without essays' do
        @no_essays[:objects][:items].first.keys.include?(:essay).should be_false
      end
    end

    context 'getting all objects' do
      before :each do
        @everything = MDL::CollectionObject.list({'collection' => 'all'})
      end

      it 'returns every object, not just permanent collection' do
        @everything[:objects][:total_count].should eq 62
      end
    end
  end

  context 'objects with extended labels' do
    before :all do 
      @extended = MDL::CollectionObject[28707]
    end

    it 'have extended labels' do
      @extended.has_extended_label?.should_not be_false
      @extended.extended_label.should_not be_nil
    end

    context 'with defaults' do
      it 'have extended labels in their resources' do
        @extended.as_resource[:extended_label].should be
      end
    end

    context 'with no_essay' do
      it 'do not have extended labels in their resources' do
        @extended.as_resource({'no_essay' => 'true'})[:extended_label].
          should_not be
      end
    end
  end

  context 'objects not in the permanent collection' do
    before :each do
      @loan = MDL::CollectionObject[30257]
    end

    it 'might not have object essays' do
      @loan.has_essay?.should be_false
      @loan.essay.should be_nil
    end
  end

  describe ".recent_acquisitions" do
    it "works" do
      recent = MDL::CollectionObject.recent_acquisitions
      recent[:objects][:items].count.should eq 1
    end
  end

end
