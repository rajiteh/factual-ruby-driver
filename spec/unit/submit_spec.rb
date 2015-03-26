require 'spec_helper'

describe Factual::Write::Submit do
  include TestHelpers

  before(:each) do
    @token = get_token
    @api = get_api(@token)
    @basic_params = {
      :table => "global",
      :user => "user123",
      :values => { :name => "McDonalds" } }
    @klass = Factual::Write::Submit
    @submit = @klass.new(@api, @basic_params)
  end

  it "should be able to write a basic submit input" do
    @submit.write
    expect(@token.last_url).to eq "http://api.v3.factual.com/t/global/submit"
    expect(@token.last_body).to eq "user=user123&values=%7B%22name%22%3A%22McDonalds%22%7D"
  end

  it "should be able to set a table" do
    @submit.table("places").write
    expect(@token.last_url).to eq "http://api.v3.factual.com/t/places/submit"
    expect(@token.last_body).to eq "user=user123&values=%7B%22name%22%3A%22McDonalds%22%7D"
  end

  it "should be able to set a user" do
    @submit.user("user456").write
    expect(@token.last_url).to eq "http://api.v3.factual.com/t/global/submit"
    expect(@token.last_body).to eq "user=user456&values=%7B%22name%22%3A%22McDonalds%22%7D"
  end

  it "should be able to set a factual_id" do
    @submit.factual_id("1234567890").write
    expect(@token.last_url).to eq "http://api.v3.factual.com/t/global/1234567890/submit"
    expect(@token.last_body).to eq "user=user123&values=%7B%22name%22%3A%22McDonalds%22%7D"
  end

  it "should be able to set values" do
    @submit.values({ :new_key => :new_value }).write
    expect(@token.last_url).to eq "http://api.v3.factual.com/t/global/submit"
    expect(@token.last_body).to eq "user=user123&values=%7B%22new_key%22%3A%22new_value%22%7D"
  end

  it "should be able to set comment and reference" do
    @submit.table("places").comment('foobar').reference('yahoo.com/d/').write
    expect(@token.last_url).to eq "http://api.v3.factual.com/t/places/submit"
    expect(@token.last_body).to eq "user=user123&values=%7B%22name%22%3A%22McDonalds%22%7D&comment=foobar&reference=yahoo.com%2Fd%2F"
  end

  it "should not allow an invalid param" do
    raised = false
    begin
      bad_submit = @klass.new(@api, :foo => "bar")
    rescue
      raised = true
    end
    expect(raised).to be_truthy
  end

  it "should be able to return a valid path if no factual_id is set" do
    expect(@submit.path).to eq "/t/global/submit"
  end

  it "should be able to return a valid path if a factual_id is set" do
    expect(@submit.factual_id("foo").path).to eq "/t/global/foo/submit"
  end

  it "should be able to return a body" do
    expect(@submit.body).to eq "user=user123&values=%7B%22name%22%3A%22McDonalds%22%7D"
  end
end
