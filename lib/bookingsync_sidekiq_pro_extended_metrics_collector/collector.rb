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

    def collect_queue_latency(queue)
      queue = queue.to_s
      latency = Sidekiq::Queue.new(queue).latency
      metric_name = build_metric_name_for_queue(queue)

      datadog_client.gauge(global_metric_name, latency, tags: ["queue:#{queue}"])
      datadog_client.gauge(metric_name, latency)
    end

    private

    def global_metric_name
      [
        METRIC_NAME_PREFIX,
        configuration.datadog_namespace,
        METRIC_NAME_SUFFIX
      ].join(METRIC_NAME_SEPARATOR)
    end

    def build_metric_name_for_queue(queue)
      [
        global_metric_name,
        queue
      ].join(METRIC_NAME_SEPARATOR)
    end
  end
end
