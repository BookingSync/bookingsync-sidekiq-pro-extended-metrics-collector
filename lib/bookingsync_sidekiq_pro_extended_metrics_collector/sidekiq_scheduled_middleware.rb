class BookingsyncSidekiqProExtendedMetricsCollector
  class SidekiqScheduledMiddleware
    def call(_worker, _job, _queue)
      yield
      BookingsyncSidekiqProExtendedMetricsCollector.collect_scheduled_count
    end
  end
end
