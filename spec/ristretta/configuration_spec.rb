# frozen_string_literal: true

RSpec.describe Ristretta::Configuration do
  before(:all) do
    Ristretta.config do |c|
      c.redis_client = Redis.new
    end
  end


  it "should create a default client" do
    expect(Ristretta::Configuration.new.client).to be_nil
  end

  it "should default namespace to 'ristretta'" do
    expect(Ristretta::Configuration.new.namespace).to be_eql('ristretta')
  end

  it "should default subject id method to ':id'" do
    expect(Ristretta::Configuration.new.subject_id_method).to be_eql(:id)
  end
end
