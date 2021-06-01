# frozen_string_literal: true

RSpec.describe Ristretta do
  it "has a version number" do
    expect(Ristretta::VERSION).not_to be nil
  end

  it "should generate an event_key" do
    subject = SampleSubject.new
    subject.id = "test"
    expect(Ristretta.event_key(
      event_subject: subject,
      event_type: 'click'
    )).to be_eql('ristretta:events:v1:samplesubject:test:click')
  end
end
