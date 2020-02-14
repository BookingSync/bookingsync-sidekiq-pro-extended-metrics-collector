class BookingsyncSidekiqProExtendedMetricsCollector
  class Configuration
    attr_accessor :datadog_host, :datadog_port, :datadog_namespace, :sidekiq_queues

    def sidekiq_queues
      @sidekiq_queues || []
    end
  end
end
