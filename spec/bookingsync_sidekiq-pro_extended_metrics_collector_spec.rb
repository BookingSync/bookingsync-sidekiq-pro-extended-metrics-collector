RSpec.describe BookingsyncSidekiqProExtendedMetricsCollector do
  it "has a version number" do
    expect(BookingsyncSidekiqProExtendedMetricsCollector::VERSION).not_to be nil
  end

  describe ".configure" do
    subject(:configuration) { described_class.configuration }

    around do |example|
      original_datadog_host = configuration.datadog_host
      original_datadog_port = configuration.datadog_port
      original_datadog_namespace = configuration.datadog_namespace

      BookingsyncSidekiqProExtendedMetricsCollector.configure do |config|
        config.datadog_host = :datadog_host
        config.datadog_port = :datadog_port
        config.datadog_namespace = :datadog_namespace
      end

      example.run

      BookingsyncSidekiqProExtendedMetricsCollector.configure do |config|
        config.datadog_host = original_datadog_host
        config.datadog_port = original_datadog_port
        config.datadog_namespace = original_datadog_namespace
      end
    end

    it "is configurable" do
      expect(configuration.datadog_host).to eq :datadog_host
      expect(configuration.datadog_port).to eq :datadog_port
      expect(configuration.datadog_namespace).to eq :datadog_namespace
    end
  end

  describe ".datadog_stats_client" do
    subject(:datadog_stats_client) { described_class.datadog_stats_client }

    it { is_expected.to be_instance_of Datadog::Statsd }
  end

  describe ".collect_queues_latency" do
    subject(:collect_queues_latency) { described_class.collect_queues_latency }

    it "calls BookingsyncSidekiqProExtendedMetricsCollector::Collector#collect_queues_latency" do
      expect_any_instance_of(BookingsyncSidekiqProExtendedMetricsCollector::Collector).to receive(:collect_queues_latency)

      collect_queues_latency
    end
  end

  describe ".collect_queue_latency" do
    subject(:collect_queue_latency) { described_class.collect_queue_latency(queue) }

    let(:queue) { "default" }

    it "calls BookingsyncSidekiqProExtendedMetricsCollector::Collector#collect_queue_latency" do
      expect_any_instance_of(BookingsyncSidekiqProExtendedMetricsCollector::Collector).to receive(:collect_queue_latency)
        .with(queue)

      collect_queue_latency
    end
  end
end
