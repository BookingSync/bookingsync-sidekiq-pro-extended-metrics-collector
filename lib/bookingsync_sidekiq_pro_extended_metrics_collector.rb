require "bookingsync_sidekiq_pro_extended_metrics_collector/configuration"
require "bookingsync_sidekiq_pro_extended_metrics_collector/collector"
require "bookingsync_sidekiq_pro_extended_metrics_collector/sidekiq_queue_latency_middleware"
require "bookingsync_sidekiq_pro_extended_metrics_collector/version"
require "datadog/statsd"

class BookingsyncSidekiqProExtendedMetricsCollector
  def self.configuration
    @configuration ||= BookingsyncSidekiqProExtendedMetricsCollector::Configuration.new
  end

  def self.configure
    yield configuration
  end

  def self.datadog_stats_client
    Datadog::Statsd.new(configuration.datadog_host, configuration.datadog_port)
  end

  def self.collect_queues_latency
    collector.collect_queues_latency
  end

  def self.collect_queue_latency(queue)
    collector.collect_queue_latency(queue)
  end

  def self.collector
    BookingsyncSidekiqProExtendedMetricsCollector::Collector.new(datadog_stats_client, configuration)
  end
  private_class_method :collector
end
