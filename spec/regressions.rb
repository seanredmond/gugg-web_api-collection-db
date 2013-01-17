# Make sure fixed bugs stay fixed
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

require 'spec_helper'

describe "permanent collection" do
  # permanent_collection was mispelled permant_collection in object resources
  it "should be spelled correctly" do
    MDL::CollectionObject[1867].as_resource.include?(:permanent_collection).
      should be_true
  end
end

describe "Degas should not cause an error" do
  it "gets a resource" do
    MDL::Constituent[931].as_resource[:objects][:count].should eq 3
  end
end

