require 'spec_helper'

describe Factual::Query::Table do
  include TestHelpers

  before(:each) do
    @token = get_token
    @api = get_api(@token)
    @table_name = "places"
    @table = Factual::Query::Table.new(@api, "t/#{@table_name}")
    @base = "http://api.v3.factual.com/t/places?"
  end

  it "should be able to do a compound query" do
    @table.filters("category" => "Food & Beverage > Restaurants").search("sushi", "sashimi")
      .geo("$circle" => {"$center" => [34.06021, -118.41828], "$meters" => 5000})
      .sort("name").page(2, :per => 10).rows
    expected_url = @base + "filters={\"category\":\"Food & Beverage > Restaurants\"}" +
      "&q=sushi,sashimi&geo={\"$circle\":{\"$center\":[34.06021,-118.41828],\"$meters\":5000}}" +
      "&sort=name&limit=10&offset=10"
    expect(CGI::unescape(@token.last_url)).to eq expected_url
  end

  it "should be able to use filters" do
    @table.filters("country" => "US").rows
    expected_url = @base + "filters={\"country\":\"US\"}"
    expect(CGI::unescape(@token.last_url)).to eq expected_url
  end

  it "should be able to search" do
    @table.search("suchi", "sashimi").rows
    expected_url = @base + "q=suchi,sashimi"
    expect(CGI::unescape(@token.last_url)).to eq expected_url
  end

  it "should be able to use a geo parameter" do
    @table.geo("$circle" => {"$center" => [34.06021, -118.41828],
               "$meters" => 5000}).rows
    expected_url = @base + "geo={\"$circle\":{\"$center\":[34.06021,-118.41828],\"$meters\":5000}}"
    expect(CGI::unescape(@token.last_url)).to eq expected_url
  end

  it "should be able to sort in ascending order" do
    @table.sort("name").rows
    expected_url = @base + "sort=name"
    expect(CGI::unescape(@token.last_url)).to eq expected_url
  end

  it "should be able to sort in descending order" do
    @table.sort_desc("name").rows
    expected_url = @base + "sort=name:desc"
    expect(CGI::unescape(@token.last_url)).to eq expected_url
  end

  it "should be able to select specific columns" do
    @table.select(:name, :website).rows
    expected_url = @base + "select=name,website"
    expect(CGI::unescape(@token.last_url)).to eq expected_url
  end

  it "should be able to limit the number of returned rows" do
    @table.limit(5).rows
    expected_url = @base + "limit=5"
    expect(CGI::unescape(@token.last_url)).to eq expected_url
  end

  it "should be able to set an offset for a query" do
    @table.offset(5).rows
    expected_url = @base + "offset=5"
    expect(CGI::unescape(@token.last_url)).to eq expected_url
  end

  it "should be able to set whether the count is included" do
    @table.include_count(true).rows
    expected_url = @base + "include_count=true"
    expect(CGI::unescape(@token.last_url)).to eq expected_url
  end

  it "should be able to set the page" do
    @table.page(5).rows
    expected_url = @base + "limit=20&offset=80"
    expect(CGI::unescape(@token.last_url)).to eq expected_url
  end

  it "should be able to get the total count" do
    @table.total_count
    expected_url = @base + "include_count=true&limit=1"
    expect(CGI::unescape(@token.last_url)).to eq expected_url
  end

  it "should be able to get a row" do
    @table.row('id123')
    expected_url = "http://api.v3.factual.com/t/places/id123"
    expect(CGI::unescape(@token.last_url)).to eq expected_url
  end

  it "should be able to get the schema" do
    @table.schema
    expected_url = "http://api.v3.factual.com/t/places/schema"
    expect(CGI::unescape(@token.last_url)).to eq expected_url
  end

  it "should be able to fetch the action" do
    expect(@table.action).to eq :read
  end

  it "should be able to fetch the path" do
    expect(@table.path).to eq "t/places"
  end

  it "should be able to fetch the params" do
    expected_params = {:filters => {"country"=>"US"}}
    expect(@table.filters("country" => "US").params).to eq expected_params
  end

  it "should be able to fetch the rows" do
    expect(@table.rows.map { |r| r["key"] }).to eq ["value1", "value2", "value3"]
  end

  it "should be able to get the first row" do
    expect(@table.first["key"]).to eq "value1"
  end

  it "should be able to get the last row" do
    expect(@table.last["key"]).to eq "value3"
  end

  it "should be able to get a value at a specific index" do
    expect(@table[1]["key"]).to eq "value2"
  end
end
