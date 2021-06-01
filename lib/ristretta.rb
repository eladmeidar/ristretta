# frozen_string_literal: true

require 'redis'
require 'redis-namespace'
require 'json'
require_relative "ext/hash"
require_relative "ristretta/version"
require_relative "ristretta/exceptions"
require_relative "ristretta/configuration"
require_relative "ristretta/event"


module Ristretta
  
  def self.config(&block)
    yield(configuration)
  end
  
  def self.client
    configuration.client
  end

  def self.event_key(options = {})
    key = "#{configuration.namespace}:events:v#{configuration.version.to_s}:#{options[:event_subject].class.name.to_s.downcase}:#{options[:event_subject].send(configuration.subject_id_method)}:#{options[:event_type]}"
    save_key_name(key)
    key
  end

  def self.clear_all_events!
    client.smembers("#{configuration.namespace}:events:keys").each do |key|
      client.del key
    end
  end

  private

  def self.save_key_name(key)
    client.sadd "#{configuration.namespace}:events:keys", key
  end

  def self.configuration
    @configuration ||= Ristretta::Configuration.new
  end
end
