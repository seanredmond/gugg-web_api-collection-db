# Tests for ObjectType class
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

require 'spec_helper'

describe MDL::ObjectType do
  before :all do
    @painting = MDL::ObjectType[195198]
  end

  describe '#name' do
    it "is right" do
      @painting.name.should eq 'Painting'
    end
  end

  describe '#objects' do
    it 'has objects' do
      @painting.objects.should be_an_instance_of Array
    end

    it 'has CollectionObject objects' do
      @painting.objects.first.should be_an_instance_of MDL::CollectionObject
    end
  end

  describe '#as_resource' do
    before :all do
      @resource = @painting.as_resource
    end

    it 'is a Hash' do
      @resource.should be_an_instance_of Hash
    end

    context 'with defaults' do
      it 'has an object count' do
        @resource[:objects][:total_count].should be > 0
      end

      it 'links to itself' do
        @resource[:_links][:_self][:href].
          should eq "http://u.r.i/collection/objects/types/#{@painting.pk}"
      end

      it 'has embedded objects' do
        @resource[:objects][:items].should be_an_instance_of Array
      end
    end

    context 'with no_objects' do
      before :all do
        @resource = @painting.as_resource({"no_objects" => true})
      end

      it 'has an object count' do
        @resource[:objects][:total_count].should be > 0
      end

      it 'has no embedded objects' do
        @resource[:objects][:items].should_not be
      end
    end
  end
end

