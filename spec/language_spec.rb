# Tests for tables without any extra implementation beyond Sequel
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

require 'spec_helper'

describe MDL::Language do
  it "should return rows" do
    # There are 14 languages as of Aug 2012
    MDL::Language.all().count.should be >= 14
  end

  it "should contain expected values" do
    MDL::Language[1].language.should eq('English')
  end

  it "should be able to retrieve associated language code" do
    MDL::Language[1].codes.language_code.should eq('en')
  end
end
