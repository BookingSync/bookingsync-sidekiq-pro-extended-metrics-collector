require "sidekiq/api"

class BookingsyncSidekiqProExtendedMetricsCollector
  class Collector
    METRIC_NAME_PREFIX = "sidekiq".freeze
    METRIC_NAME_SEPARATOR = ".".freeze
    LATENCY_METRIC_NAME_SUFFIX = "queue_latency".freeze
    RETRY_IDENTIFIER = "retry_count".freeze
    SCHEDULED_IDENTIFIER = "scheduled_count".freeze
    private_constant :METRIC_NAME_PREFIX,  :METRIC_NAME_SEPARATOR, :LATENCY_METRIC_NAME_SUFFIX,
      :RETRY_IDENTIFIER, :SCHEDULED_IDENTIFIER

    attr_reader :datadog_client, :configuration
    private     :datadog_client, :configuration

    def initialize(datadog_client, configuration)
      @datadog_client = datadog_client
      @configuration = configuration
    end

    def collect_queue_latency(queue)
      queue = queue.to_s
      latency = Sidekiq::Queue.new(queue).latency
      metric_name = build_metric_name_for_queue_latency(queue)

      datadog_client.gauge(global_metric_name_for_latency, latency, tags: ["queue:#{queue}"])
      datadog_client.gauge(metric_name, latency)
    end

    def collect_retry_count
      size = Sidekiq::RetrySet.new.size
      datadog_client.gauge(build_metric_name_for_retry, size)
    end

    def collect_scheduled_count
      size = Sidekiq::ScheduledSet.new.size
      datadog_client.gauge(build_metric_name_for_scheduled, size)
    end

    private

    def global_metric_name_for_latency
      [
        METRIC_NAME_PREFIX,
        configuration.datadog_namespace,
        LATENCY_METRIC_NAME_SUFFIX
      ].join(METRIC_NAME_SEPARATOR)
    end

    def build_metric_name_for_queue_latency(queue)
      [
        global_metric_name_for_latency,
        queue
      ].join(METRIC_NAME_SEPARATOR)
    end

    def build_metric_name_for_retry
      [
        METRIC_NAME_PREFIX,
        configuration.datadog_namespace,
        RETRY_IDENTIFIER
      ].join(METRIC_NAME_SEPARATOR)
    end

    def build_metric_name_for_scheduled
      [
        METRIC_NAME_PREFIX,
        configuration.datadog_namespace,
        SCHEDULED_IDENTIFIER
      ].join(METRIC_NAME_SEPARATOR)
    end
  end
end
