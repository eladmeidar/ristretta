module Ristretta
  class Event
    attr_reader :event_attrs, :timestamp

    def initialize(event_attrs, timestamp)
      @event_attrs = JSON.parse(event_attrs)
      @timestamp = timestamp.to_i
    end

    def Event.create(event_subject, event_type, event_attrs, timestamp = Time.now.to_i)
      Ristretta.client.zadd(Ristretta.event_key({
        event_type: event_type,
        event_subject: event_subject
      }), timestamp, (event_attrs.merge(timestamp: timestamp.to_i)).to_json, nx: true)
    end

    def Event.find(options = {})
      raise(Exceptions::SubjectNotSpecified, "event_subject must be specified") if options[:event_subject].nil?
      raise(Exceptions::TypeNotSpecified, "event_type must be specified") if options[:event_type].nil?

      start_timestamp = options[:since].to_i
      end_timestamp = options[:until] || Time.now.to_i
      
      Ristretta.client.zrangebyscore(Ristretta.event_key(options), start_timestamp, end_timestamp, with_scores: true).collect do |event_data|
        self.new(event_data.first, event_data.last.to_i)
      end
    end
  end
end