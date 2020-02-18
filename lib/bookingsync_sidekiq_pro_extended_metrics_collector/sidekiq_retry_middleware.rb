class BookingsyncSidekiqProExtendedMetricsCollector
  class SidekiqRetryMiddleware
    def call(_worker, _job, _queue)
      yield
      BookingsyncSidekiqProExtendedMetricsCollector.collect_retry_count
    end
  end
end
