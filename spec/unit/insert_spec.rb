require 'spec_helper'

describe Factual::Write::Insert do
  include TestHelpers

  before(:each) do
    @token = get_token
    @api = get_api(@token)
    @basic_params = {
      :table => "global",
      :user => "user123",
      :values => { :name => "McDonalds" } }
    @klass = Factual::Write::Insert
    @insert = @klass.new(@api, @basic_params)
  end

  it "should be able to write a basic insert input" do
    @insert.write
    expect(@token.last_url).to eq "http://api.v3.factual.com/t/global/insert"
    expect(@token.last_body).to eq "user=user123&values=%7B%22name%22%3A%22McDonalds%22%7D"
  end

  it "should be able to set a table" do
    @insert.table("places").write
    expect(@token.last_url).to eq "http://api.v3.factual.com/t/places/insert"
    expect(@token.last_body).to eq "user=user123&values=%7B%22name%22%3A%22McDonalds%22%7D"
  end

  it "should be able to set a user" do
    @insert.user("user456").write
    expect(@token.last_url).to eq "http://api.v3.factual.com/t/global/insert"
    expect(@token.last_body).to eq "user=user456&values=%7B%22name%22%3A%22McDonalds%22%7D"
  end

  it "should not be able to set a factual_id" do
    raised = false
    begin
      @insert.factual_id("1234567890").write
    rescue
      raised = true
    end
    expect(raised).to be_truthy
  end

  it "should be able to set values" do
    @insert.values({ :new_key => :new_value }).write
    expect(@token.last_url).to eq "http://api.v3.factual.com/t/global/insert"
    expect(@token.last_body).to eq "user=user123&values=%7B%22new_key%22%3A%22new_value%22%7D"
  end

  it "should be able to set comment and reference" do
    @insert.table("places").comment('foobar').reference('yahoo.com/d/').write
    expect(@token.last_url).to eq "http://api.v3.factual.com/t/places/insert"
    expect(@token.last_body).to eq "user=user123&values=%7B%22name%22%3A%22McDonalds%22%7D&comment=foobar&reference=yahoo.com%2Fd%2F"
  end

  it "should not allow an invalid param" do
    raised = false
    begin
      bad_insert = @klass.new(@api, :foo => "bar")
    rescue
      raised = true
    end
    expect(raised).to be_truthy
  end

  it "should be able to return a valid path if no factual_id is set" do
    expect(@insert.path).to eq "/t/global/insert"
  end

  it "should be able to return a body" do
    expect(@insert.body).to eq "user=user123&values=%7B%22name%22%3A%22McDonalds%22%7D"
  end
end
