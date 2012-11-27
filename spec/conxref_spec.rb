# Tests for tables without any extra implementation beyond Sequel
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

require 'spec_helper'

describe MDL::ConstituentXref do
  context "gutai" do
    before :all do 
      @xref = MDL::ConstituentXref[1916]
      @c = MDL::Constituent[1515]
    end

    it "should work" do
      @xref.should be_an_instance_of MDL::ConstituentXref
      @c.should be_an_instance_of MDL::Constituent
    end

    it "should have a non-nil constituent" do
      @xref.constituent.should_not be_nil
    end
  end


end

