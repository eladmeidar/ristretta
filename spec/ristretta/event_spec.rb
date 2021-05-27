# frozen_string_literal: true

RSpec.describe Ristretta::Event do

  before(:each) do
    Ristretta.clear_all_events!
  end

  it "should successfully create an event" do
    sample = SampleSubject.new
    sample.id = 2
    expect(Ristretta::Event.create(sample, 'click', {button: 'happy'})).to be_eql(true)
  end

  it "should read a single event when quering for all" do
    sample = SampleSubject.new
    sample.id = 2
    Ristretta::Event.create(sample, 'click', {button: 'happy'})
    expect(Ristretta::Event.find(
      event_subject: sample,
      event_type: 'click'
    ).length).to be_eql(1)

    expect(Ristretta::Event.find(
      event_subject: sample,
      event_type: 'click'
    ).first.event_attrs["button"]).to be_eql('happy')
  end

  it "should not find an event out of search range" do
    sample = SampleSubject.new
    sample.id = 2
    Ristretta::Event.create(sample, 'click', {button: 'old'}, Time.now.to_i - (3 * 24 * 60 * 60))
    expect(Ristretta::Event.find(
      event_subject: sample,
      event_type: 'click',
      since: Time.now.to_i - 3600 * 3
    ).length).to be_eql(0)

    expect(Ristretta::Event.find(
      event_subject: sample,
      event_type: 'click',
    ).length).to be_eql(1)
  end
end
