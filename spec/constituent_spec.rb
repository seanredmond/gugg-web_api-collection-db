# Tests for tables without any extra implementation beyond Sequel
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

require 'spec_helper'

describe MDL::Constituent do
  before :all do
    @kandinsky = MDL::Constituent[1515]
  end

  it "should have a last name" do
    @kandinsky.lastname.should eq "Kandinsky"
  end

  it "should have a first name" do
    @kandinsky.firstname.should eq "Vasily"
  end

  it "should have a middle name" do
    @kandinsky.middlename.should be_nil
  end

  it "should have a display name" do
    @kandinsky.displayname.should eq "Vasily Kandinsky"
  end

  it "should have a sort name" do
    @kandinsky.alphasort.should eq "Kandinsky, Vasily"
  end

  describe "#bio" do
    it "should have a bio" do
      @kandinsky.bio.should_not be_nil
    end
  end

  describe "#has_bio?" do
    it "should say whether it has a bio" do
      @kandinsky.has_bio?.should be_true
    end
  end

  describe ".list" do
    context "with defaults" do
      it "should work" do
        MDL::Constituent.list[:constituents].count.should eq 16
      end
    end

    context "with initial parameter" do
      it "should return only names beginning with the given letter" do
        with_b = MDL::Constituent.list({'initial' => 'b'})
        with_b[:constituents].map{|c| c[:sort][0,1].upcase}.uniq.should eq ["B"]
      end

      context "that is not a string" do
        it "should raise a BadParameterError" do 
          expect {
            MDL::Constituent.list({'initial' => false})            
          }.to raise_error(MDL::BadParameterError, /must be a single letter/)
        end
      end

      context "that is an invalid string" do
        it "should raise a BadParameterError" do 
          expect {
            MDL::Constituent.list({'initial' => '0'})            
          }.to raise_error(MDL::BadParameterError, /must be a single letter/)
        end
      end
    end
  end

  describe "#as_resource" do
    it "should return a Hash" do
      @kandinsky.as_resource.should be_an_instance_of Hash
    end

    # We decided not to export the nationality from TMS because "so many 
    # different artists have so many different opinions"
    it "does not have a nationality" do
      @kandinsky.as_resource[:nationality].should_not be
    end

    it "has a bio" do
      @kandinsky.as_resource[:bio].should_not be_nil
    end

    it "says whether it has a bio" do
      @kandinsky.as_resource[:has_bio].should be_true
    end

    context "with no_bio" do
      it "does not have a bio" do
        @kandinsky.as_resource({'no_bio' => 1})[:bio].should be_nil
      end

      it "still says it has a bio" do
        @kandinsky.as_resource({'no_bio' => 1})[:has_bio].should be_true
      end
    end
  end
end

describe MDL::ConstituentXref do
  before :all do
    @xref = MDL::ConstituentXref[1973]
  end

  it "should be a ConstituentXref" do
    @xref.should be_an_instance_of MDL::ConstituentXref
  end

  it "should be connected to a CollectionObject" do
    @xref.object.should be_an_instance_of MDL::CollectionObject
  end

  it "should be connected to a Constituent" do
    @xref.constituent.should be_an_instance_of MDL::Constituent
  end

  it "should be connected to a Role" do
    @xref.role.should be_an_instance_of MDL::Role
  end

end

