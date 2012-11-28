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
  end
end

