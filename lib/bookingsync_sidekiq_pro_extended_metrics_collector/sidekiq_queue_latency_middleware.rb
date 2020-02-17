class BookingsyncSidekiqProExtendedMetricsCollector
  class SidekiqQueueLatencyMiddleware
    def call(_worker, _job, queue)
      BookingsyncSidekiqProExtendedMetricsCollector.collect_queue_latency(queue)
      yield
    end
  end
end
