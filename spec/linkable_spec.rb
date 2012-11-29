# Tests for tables without any extra implementation beyond Sequel
#
# Author:: Sean Redmond <sredmond@guggenheim.org>
# Copyright:: Copyright © 2012 Solomon R. Guggenheim Foundation
# License GPLv3

require 'spec_helper'

describe Gugg::WebApi::Collection do
  before :all do
    Gugg::WebApi::Collection::Linkable::root = "http://u.r.i/collection"
    Gugg::WebApi::Collection::Linkable::map_path(
      Gugg::WebApi::Collection::Db::CollectionObject, 'objects'
    )
    Gugg::WebApi::Collection::Linkable::map_path(
      Gugg::WebApi::Collection::Db::Acquisition, 'acquisitions'
    )
    @pwb = MDL::CollectionObject[1867]

  end

  describe "#self_link" do
    it "returns a link" do
      @pwb.self_link[:_self][:href].should eq 'http://u.r.i/collection/objects/1867'
    end

    context "with an object that implements Collectible" do
      before :all do
        # Thannhauser Collection
        @acq_id = 4
        @acq = MDL::Acquisition[@acq_id]
      end

      context "with defaults" do
        before :all do
          @res = @acq.as_resource
        end

        it "should return a Hash" do
          @res.should be_an_instance_of Hash
        end

        it "should have objects" do
          @res[:objects].should be_an_instance_of Hash
        end

        it "should link to itself" do
          @res[:_links][:_self][:href].
            should eq "http://u.r.i/collection/acquisitions/#{@acq_id}"
        end
        it "should link to page 2" do
          @res[:_links][:next][:href].
            should start_with "http://u.r.i/collection/acquisitions/#{@acq_id}"
          @res[:_links][:next][:href].should include "page=2"
          @res[:_links][:next][:href].should include "per_page=20"
        end
      end

      context "with options" do
        context "for page" do
          before :all do
            @res = @acq.as_resource({'per_page' => 5, 'page' => 2})
          end

          it "should link to previous page 1" do
            @res[:_links][:prev][:href].should include "page=1"
          end

          it "should not link to next page 3" do
            @res[:_links][:next][:href].should include "page=3"
          end
        end

        context "for items per page" do
          before :all do
            @res = @acq.as_resource({'per_page' => 5})
          end

          it "should link to next page 3" do
            @res[:_links][:next][:href].should include "page=2"
            @res[:_links][:next][:href].should include "per_page=5"
          end
        end

        context "for page and items per page" do
          before :all do
            @res = @acq.as_resource({'page' => 2, 'per_page' => 5})
          end

          it "should link to previous page 1" do
            @res[:_links][:prev][:href].should include "page=1"
            @res[:_links][:prev][:href].should include "per_page=5"
          end

          it "should link to next page 3" do
            @res[:_links][:next][:href].should include "page=3"
            @res[:_links][:next][:href].should include "per_page=5"
          end
        end

        context "with no_objects" do
          before :all do
            @res = @acq.as_resource({'no_objects' => 1})
          end

          it "should link to itself" do
            @res[:_links][:_self][:href].
              should start_with "http://u.r.i/collection/acquisitions/#{@acq_id}"
          end

          it "should not repeat the no_objects parameter" do
            @res[:_links][:_self][:href].should_not include "no_objects"
          end

          it "should not link to another page" do
            @res[:_links][:next].should be_nil
          end
        end
      end
    end
  end
end

