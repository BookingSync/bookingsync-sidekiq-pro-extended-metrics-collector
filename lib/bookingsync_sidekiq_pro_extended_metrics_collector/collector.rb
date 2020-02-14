require "sidekiq/api"

class BookingsyncSidekiqProExtendedMetricsCollector
  class Collector
    METRIC_NAME_PREFIX = "sidekiq".freeze
    METRIC_NAME_SUFFIX = "queue_latency".freeze
    METRIC_NAME_SEPARATOR = ".".freeze
    private_constant :METRIC_NAME_PREFIX, :METRIC_NAME_SUFFIX, :METRIC_NAME_SEPARATOR

    attr_reader :datadog_client, :configuration
    private     :datadog_client, :configuration

    def initialize(datadog_client, configuration)
      @datadog_client = datadog_client
      @configuration = configuration
    end

    def collect_queues_latency
      configuration.sidekiq_queues.each(&method(:collect_queue_latency))
    end

    def collect_queue_latency(queue)
      latency = Sidekiq::Queue.new(queue.to_s).latency
      metric_name = build_metric_name_for_queue(queue)

      datadog_client.gauge(metric_name, latency)
    end

    private

    def build_metric_name_for_queue(queue)
      [
        METRIC_NAME_PREFIX,
        configuration.datadog_namespace,
        METRIC_NAME_SUFFIX,
        queue
      ].join(METRIC_NAME_SEPARATOR)
    end
  end
end
