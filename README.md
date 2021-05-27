# Ristretta

Ristretta is a library that allows easily collecting event data in Redis sorted sets. It uses a timestamp as the event score to ensure the oridnality.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ristretta'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ristretta

## Usage

### Configuration

Ristretta accepts a configuration block that allows the following options:

```ruby
Ristretta.config do |config|
    config.redis_client = redis # a pre-configured Redis client
    config.namespace = 'ristretta' # namespace for all your redis keys
    config.version = 1 # easily expire all previous event collectors
    config.subject_id_method = :id # This is the method that will be used to extract an unique id for the passed event_subject instance
end

```

### Recording Events

```ruby
Ristretta::Event.create(event_subject, event_type, event_attrs, timestamp)
```

| Parameter | Description | Required | Default |
| --------- | ----------- | -------- | ------- |
| event_subject | the object that the event will be associated with | V | X |
| event_type | the event name (string) | V | X |
| event_attrs | hash with the event details | x | `{}` |
| timestamp | the event timestamp | x | `Time.now.to_i` |


### Fetching Events

```ruby
Ristretta::Event.find(options = {})
```

`options` includes the following keys:

| key | Description | Required | Default |
| --------- | ----------- | -------- | ------- |
| event_subject | the object that the event will be associated with | V | X |
| event_type | the event name (string) | V | X |
| since | timestamp of the olders event you want | x | beginning of time |
| until | timestamp of the newest event you want | x | `Time.now.to_i` |

the returned value is a series of time ordered events (new to old) that will respond to `event_attrs` and `timestamp`

## 
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eladmeidar/ristretta.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
