# Tests for tables without any extra implementation beyond Sequel
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

require 'spec_helper'

describe MDL::LanguageCode do
  it "should return rows" do
    # There are 12 language codes as of Aug 2012
    MDL::LanguageCode.all().count.should be >= 12
  end

  it "should contain expected values" do
    MDL::LanguageCode[1].language_code.should eq('en')
  end
end

describe MDL::MediaType do
  it "should return rows" do
    # There are 9 media types as of Aug 2012
    MDL::MediaType.all().count.should be >= 9
  end

  it "should contain expected values" do
    MDL::MediaType[1].mediatype.should eq('Image')
  end
end

describe MDL::ObjectContext do
  it "should return rows" do
    MDL::ObjectContext.all().count.should eq 57
  end

  it "should contain expected fields" do
    context = MDL::ObjectContext.first
    context.longtext7.should be
    context.flag5.should be
    context.flag6.should be
  end
end

# describe MDL::SortFields do
#   it "should return rows" do
#     # There are 88 roles as of Aug 2012
#     MDL::SortFields.all().count.should be >= 977
#   end

#   it "should contain expected values" do
#     MDL::SortFields[2].title.should eq('Villa Borghese')
#   end

#   describe '#objlocation' do
#     before :all do
#       @woman_ironing = MDL::SortFields[3417]
#     end

#     it 'returns a Location object' do
#       @woman_ironing.objlocation.should be_an_instance_of MDL::Location
#     end

#     it 'is where expected' do
#       @woman_ironing.objlocation.area.should eq 'Ramp 1'
#       @woman_ironing.objlocation.location.should eq 'Bay 14'
#     end
#   end
# end

describe MDL::Role do
  it "should return rows" do
    # There are 88 roles as of Aug 2012
    MDL::Role.all().count.should be >= 88
  end

  it "should contain expected values" do
    MDL::Role[1].role.should eq('Artist')
  end
end

describe MDL::TextEntry do
  it "should return rows" do
    MDL::TextEntry.all().count.should eq 15
  end

  it "should contain expected values" do
    (MDL::TextEntry[17070].textentry =~ /Georges Braque/).should be_true
  end
end

describe MDL::TitleType do
  it "should return rows" do
    # There are 13 title types as of Aug 2012
    MDL::TitleType.all().count.should be >= 13
  end

  it "should contain expected values" do
    MDL::TitleType[3].titletype.should eq('Original Title')
  end
end

