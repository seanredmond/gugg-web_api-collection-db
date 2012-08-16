# Tests for tables without any extra implementation beyond Sequel
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

require "rubygems"
require "sequel"
require "yaml"

cfg = YAML.load_file('collection_db_spec.yml')
db = cfg['db']['mysql']
@DB = Sequel.mysql(db['db'], :user=>db['user'], :password=>db['password'], 
  :host=>db['host'], :charset=>'utf8')

require 'gugg-web_api-collection-db'

MDL = Gugg::WebApi::Collection::Db

describe MDL::CollectionObject do
  before :all do
    @pwb = MDL::CollectionObject[1867]
  end

  describe "#titles" do
    it "should return a TitleGroup" do
      @pwb.titles.should be_an_instance_of MDL::TitleGroup
    end

   #  it "should not have a sort title" do
   #  	# We used to include a sort title in the titles resource, but this is 
   #  	# redundant as the main object already has a sort_title property
   #  	@pwb.titles[:sort].should_not be
  	# end

  	# it "should not have ids for titles" do
  	# 	# Title resources used to have an id, but this has no meaning to the end 
  	# 	#user
  	# 	@pwb.titles[:primary][:id].should_not be
  	# end
  end

  describe "#series" do
  	context "when the object has no series" do
  		it "should return nothing" do
  			@pwb.series.should be_nil
  		end
  	end

  	context "when the object has a series" do
  		it "should return an ObjectTitle" do
  			MDL::CollectionObject[5214].series.
  				should be_an_instance_of(MDL::ObjectTitle)
			end
		end
  end
end

describe MDL::TitleGroup do
  before :all do
    @pwb = MDL::CollectionObject[1867]
    @titles = @pwb.titles
  end

  it "should have a primary title" do
  	@titles.primary.should be_an_instance_of(MDL::ObjectTitle)
  end

  it "should have other titles" do
  	@titles.other.should be_an_instance_of(Array)
  end

  it "should have other titles that are ObjectTitle objects" do
  	@titles.other.each do |t|
  		t.should be_an_instance_of(MDL::ObjectTitle)
  	end
  end

  describe "#as_resource" do
  	it "should return a hash" do
  		@titles.as_resource.should be_an_instance_of(Hash)
  	end

  	context "when there are other titles" do
	  	it "should have a primary title" do
	  		@titles.as_resource[:primary].should_not be_nil
	  	end

	  	it "should have other titles" do
	  		@titles.as_resource[:other].should be_an_instance_of(Array)
	  	end
	  end

  	context "when there are not other titles" do
  		before :all do 
  			@doloresjames = MDL::CollectionObject[803].titles
  		end

	  	it "should have a primary title" do
	  		@doloresjames.as_resource[:primary].should_not be_nil
	  	end

	  	it "should not have other titles" do
	  		@doloresjames.as_resource[:other].should be_nil
	  	end
	  end
	end
end

describe MDL::ObjectTitle do
  before :all do
    @pwb = MDL::CollectionObject[1867]
    @primary = @pwb.titles.primary
  end

	describe "#as_resource" do
		before :all do
			@primary_r = @primary.as_resource
		end

		it "should be a Hash" do
			@primary_r.should be_an_instance_of(Hash)
		end

		context "when it is not a series title" do
			it "should not have a prefix or suffix" do
				@primary_r[:prepend].should be_nil
				@primary_r[:append].should be_nil
			end
		end

		context "when it is a series title" do
			before :all do
				@series7 = MDL::CollectionObject[13142].series.as_resource
				@series15 = MDL::CollectionObject[5214].series.as_resource
				@series16 = MDL::CollectionObject[5220].series.as_resource
			end

			it "Should have the type 'Series'" do
				@series7[:type].should eq("Series")
			end

			context "when it has a titletypeid of 7" do
				it "should have the right prefix" do
					@series7[:prepend].should eq('from the series')
				end

				it "should have the right suffix" do
					@series7[:append].should be_nil
				end
			end

			context "when it has a titletypeid of 15" do
				it "should have the right prefix" do
					@series15[:prepend].should eq('from the')
				end

				it "should have the right suffix" do
					@series15[:append].should eq('series')
				end
			end

			context "when it has a titletypeid of 16" do
				it "should have the right prefix" do
					@series16[:prepend].should eq('from')
				end

				it "should have the right suffix" do
					@series16[:append].should be_nil
				end
			end
		end
	end
end

