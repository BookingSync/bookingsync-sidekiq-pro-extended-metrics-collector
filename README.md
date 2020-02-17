# BookingsyncSidekiqProExtendedMetricsCollector

A gem for collecting extra Sidekiq metrics and aggregating them in Datadog.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bookingsync-sidekiq-pro-extended-metrics-collector'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bookingsync-sidekiq-pro-extended-metrics-collector

## Usage

### Configuration

Add this to the initializer:

``` rb
Rails.application.config.to_prepare do
  BookingsyncSidekiqProExtendedMetricsCollector.configure do |config|
    config.datadog_host = ENV.fetch("DATADOG_HOST")
    config.datadog_port = ENV.fetch("DATADOG_PORT")
    config.datadog_namespace = ENV.fetch("DATADOG_NAMESPACE")
  end
end
```

### Queues' latencies

Add this Sidekiq middleware in the Sidekiq config:

``` rb
Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    if Rails.env.production?
      chain.add BookingsyncSidekiqProExtendedMetricsCollector::SidekiqQueueLatencyMiddleware
    end
  end
end
```

That will be enough to start collecting metrics for queues' latencies. You can perform a search based on a given namespace like `bookingsync.production`, `queue_latency` and `sidekiq` keywords. The metrics are aggregated "globally" (where queue name is used a tag) and separtely by each queue.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/bookingsync-sidekiq-pro-extended-metrics-collector.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
