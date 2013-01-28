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

describe "Paginated link format" do
  # API was generating URLs like:
  # http://api.guggenheim.org/collections/objects/?page=2
  it "should not have a slash before a question mark" do
    obj = MDL::CollectionObject.list
    puts obj[:_links][:next][:href]
    obj[:_links][:next][:href].should_not include '/?'
  end

  # Fix for the previous bug also removed trailing slashes from object-by-year
  # endpoints, which is better anyway
  it "object-by-year endpoints should not have trailing slashes" do
    @by_year = MDL::CollectionObject.by_year(1923, {:add_to_path => 'dates'})
    @by_range = MDL::CollectionObject.
      by_year_range(1923, 1933, {:add_to_path => 'dates'})

    @by_year[:_links][:_self][:href].should_not end_with('1923/')
    @by_range[:_links][:_self][:href].should_not end_with('1933/')
  end
end

describe "Correct artist bios" do
  # Incorrect field was exported as the artist bio and some constituents lacked
  # any bio at all

  it "Afro has a bio" do
    afro = MDL::Constituent[534]
    afro.firstname.should eq "Afro"
    afro.bio.should_not be_nil
  end
end


