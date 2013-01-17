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

# Once we added Tannhauser and Kandinsky as exhibitions, many of the objects
# had no locations in those exhibitions, which caused crashes when 
# nil.as_resource was called. The test data has to manually recreate this
# situation because no exhibitions are dumped for testing.
describe "Degas should not cause an error" do
  it "does not crash on Degas' work #1006" do
    MDL::CollectionObject[1006].as_resource.
      should be_an_instance_of Hash
  end

  it "Does not crash on Degas" do
    MDL::Constituent[931].as_resource[:objects][:count].should eq 3
  end

end

