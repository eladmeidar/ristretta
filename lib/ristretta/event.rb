module Ristretta
  class Event
    attr_reader :event_type, :event_attrs, :timestamp

    def initialize(event_type, event_attrs, timestamp)
      @event_type = event_type
      @event_attrs = JSON.parse(event_attrs)
      @timestamp = timestamp.to_i
    end

    def Event.create(options = {}, timestamp = Time.now.to_i)
      payload = options[:event_attrs].merge(timestamp: timestamp.to_i)
      payload[:subject_id] = options[:event_object].send(Ristretta.configuration.subject_id_method)
      payload[:subject_class] = options[:event_object].class.name

      Ristretta.client.zadd(Ristretta.event_key({
        event_type: options[:event_type],
        event_subject: options[:event_subject]
      }), timestamp, payload.to_json, nx: true)
    end
    
    def Event.find(options = {})
      raise(Exceptions::SubjectNotSpecified, "event_subject must be specified") if options[:event_subject].nil?
      raise(Exceptions::TypeNotSpecified, "event_type must be specified") if options[:event_type].nil?

      start_timestamp = options[:since].to_i
      end_timestamp = options[:until] || Time.now.to_i
      query = options[:query]
      objects = Ristretta.client.zrangebyscore(Ristretta.event_key(options), start_timestamp, end_timestamp, with_scores: true).collect do |event_data|
        attrs, timestamp = event_data
        self.new(options[:event_type], attrs, timestamp)
      end
      if query.nil?
        objects
      else
        objects.select { |obj| obj.event_attrs.contains?(query)}
      end
    end

    def Event.delete(options)
      start_timestamp = options[:since].to_i
      end_timestamp = options[:until] || Time.now.to_i

      Ristretta.client.zrangebyscore(Ristretta.event_key(options), start_timestamp, end_timestamp, with_scores: true).collect do |event_data|
        attrs, _ = event_data
        attrs = JSON.parse(attrs).map { |k, v| [k.to_sym, v] }.to_h
        if attrs.contains?(options[:event_attrs])
          Ristretta.client.zrem(Ristretta.event_key(options),attrs.to_json)
        end
      end
    end
  end
end