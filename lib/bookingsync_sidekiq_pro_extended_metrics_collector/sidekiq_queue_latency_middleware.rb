class BookingsyncSidekiqProExtendedMetricsCollector
  class SidekiqQueueLatencyMiddleware
    def call(_worker, _job, queue)
      yield
      BookingsyncSidekiqProExtendedMetricsCollector.collect_queue_latency(queue)
    end
  end
end
