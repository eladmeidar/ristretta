# frozen_string_literal: true

RSpec.describe Ristretta::Configuration do
  it "should create a default client" do
    expect(Ristretta::Configuration.new.client).not_to be nil
  end

  it "should default namespace to 'ristretta'" do
    expect(Ristretta::Configuration.new.namespace).to be_eql('ristretta')
  end

  it "should default subject id method to ':id'" do
    expect(Ristretta::Configuration.new.subject_id_method).to be_eql(:id)
  end
end
