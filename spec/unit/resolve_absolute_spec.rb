require 'spec_helper'

describe Factual::Query::Resolve do
  include TestHelpers

  before(:each) do
    @token = get_token
    @api = get_api(@token)
    @resolve = Factual::Query::ResolveAbsolute.new(@api, "places")
    @base = "http://api.v3.factual.com/t/places/resolve-absolute?"
  end

  it "should be able to set values" do
    @resolve.values({:name => "McDonalds"}).rows
    expected_url = @base + "values={\"name\":\"McDonalds\"}"
    expect(CGI::unescape(@token.last_url)).to eq expected_url
  end

  it "should be able to get the total count" do
    @resolve.total_count
    expected_url = @base + "include_count=true&limit=1"
    expect(CGI::unescape(@token.last_url)).to eq expected_url
  end

  it "should be able to fetch the action" do
    expect(@resolve.action).to eq :read
  end

  it "should be able to fetch the path" do
    expect(@resolve.path).to eq "t/places/resolve-absolute"
  end

  it "should be able to fetch the rows" do
    expect(@resolve.rows.map { |r| r["key"] }).to eq ["value1", "value2", "value3"]
  end

  it "should be able to get the first row" do
    expect(@resolve.first["key"]).to eq "value1"
  end

  it "should be able to get the last row" do
    expect(@resolve.last["key"]).to eq "value3"
  end

  it "should be able to get a value at a specific index" do
    expect(@resolve[1]["key"]).to eq "value2"
  end
end
