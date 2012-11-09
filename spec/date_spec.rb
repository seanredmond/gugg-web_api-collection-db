# Tests for date resources
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

require 'spec_helper'

describe "MDL.date_resource" do
  it "should return a Hash" do
    MDL.date_resource(1900, 1910, "1900-1910").should be_an_instance_of Hash
  end

  it "should convert 0 dates to nil" do
    d = MDL.date_resource(1900, 0, "1900-1910")
    d[:end].should be_nil
  end
end
