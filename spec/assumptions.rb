# Tests for some assumptions about the data
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

require 'spec_helper'

describe "Acquisitions" do
  before :all do
    @o = MDL::CollectionObject.all
  end

  # Objects should belong to 0 or 1 acquisitions. This is required for 
  # CollectionObject#acquisition to have the right meaning since it returns
  # one acquisition or nil. 
  #
  # The object's acquisitions association returns an array, but only because a 
  # many-to-many relationship is required by the schema (two tables joined by 
  # an intermediate mapping table). The assumption is that if the database were 
  # designed differently each object could have one acquisition id. Following 
  # this assumption the one object that CollectionObject#acquisitions returns is
  # the first, and presumed only, member of the array. If any object were found 
  # to belong to two acquisitions we would have to get rid of this method.
  context "Acquisition counts" do
    it "some objects should be in no acquisition" do
      @o.select{|o| o.acquisitions.count == 0}.
        should have_at_least(1).items
    end

    it "some objects should be in one acquisition" do
      @o.select{|o| o.acquisitions.count == 1}.
        should have_at_least(1).items
    end

    it "no objects should be in more than one acquisition" do
      @o.select{|o| o.acquisitions.count > 1}.count.
        should eq 0
    end
  end
end
