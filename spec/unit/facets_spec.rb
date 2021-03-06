require 'spec_helper'

describe Factual::Query::Facets do
  include TestHelpers

  before(:each) do
    @token = get_token(:facets)
    @api = get_api(@token)
    @table_name = "places"
    @facets = Factual::Query::Facets.new(@api, "t/#{@table_name}").select("category", "locality")
    @base = "http://api.v3.factual.com/t/places/facets?" +
      "select=category,locality&"
  end

  it "should be able to do a compound query" do
    @facets.filters("category" => "Food & Beverage > Restaurants").search("sushi", "sashimi")
      .geo("$circle" => {"$center" => [34.06021, -118.41828], "$meters" => 5000})
      .limit(10).rows
    expected_url = @base + "filters={\"category\":\"Food & Beverage > Restaurants\"}" +
      "&q=sushi,sashimi&geo={\"$circle\":{\"$center\":[34.06021,-118.41828],\"$meters\":5000}}" +
      "&limit=10"
    expect(CGI::unescape(@token.last_url)).to eq expected_url
  end

  it "should be abled to get facets by column" do
    columns = @facets.columns
    expect(columns.class).to eq Hash

    category_facets = @facets['category']
    category_facets.each do |cat, num|
      expect(num.is_a?(Integer)).to be_truthy
    end
  end
end
