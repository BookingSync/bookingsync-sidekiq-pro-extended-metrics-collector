require "sidekiq"

RSpec.describe BookingsyncSidekiqProExtendedMetricsCollector::Collector do
  let(:datadog_client) do
    Class.new do
      attr_reader :registry

      def initialize
        @registry = []
      end

      def gauge(name, value, tags: [])
        @registry << { name => [value, tags] }
      end
    end.new
  end
  let(:configuration) do
    BookingsyncSidekiqProExtendedMetricsCollector::Configuration.new.tap do |config|
      config.datadog_namespace = "metrics_collector"
    end
  end

  describe "#collect_queue_latency" do
    subject(:collect_queue_latency) do
      described_class.new(datadog_client, configuration).collect_queue_latency("default")
    end

    let(:default_queue) { double(:default_queue, latency: 5.73) }
    let(:expected_result) do
      [
        { "sidekiq.metrics_collector.queue_latency" => [5.73, ["queue:default"]] },
        { "sidekiq.metrics_collector.queue_latency.default" => [5.73, []] }
      ]
    end

    before do
      allow(Sidekiq::Queue).to receive(:new).with("default") { default_queue }
    end

    it "it collects latency metrics for specified queue" do
      expect {
        collect_queue_latency
      }.to change { datadog_client.registry }.from([]).to(expected_result)
    end
  end

  describe "#collect_retry_count" do
    subject(:collect_retry_count) do
      described_class.new(datadog_client, configuration).collect_retry_count
    end

    let(:retry_set) { double(:retry_set, size: 11) }
    let(:expected_result) do
      [
        { "sidekiq.metrics_collector.retry_count" => [11, []] }
      ]
    end

    before do
      allow(Sidekiq::RetrySet).to receive(:new) { retry_set }
    end

    it "it collects retry count metrics" do
      expect {
        collect_retry_count
      }.to change { datadog_client.registry }.from([]).to(expected_result)
    end
  end

  describe "#collect_scheduled_count" do
    subject(:collect_scheduled_count) do
      described_class.new(datadog_client, configuration).collect_scheduled_count
    end

    let(:scheduled_set) { double(:scheduled_set, size: 11) }
    let(:expected_result) do
      [
        { "sidekiq.metrics_collector.scheduled_count" => [11, []] }
      ]
    end

    before do
      allow(Sidekiq::ScheduledSet).to receive(:new) { scheduled_set }
    end

    it "it collects scheduled count metrics" do
      expect {
        collect_scheduled_count
      }.to change { datadog_client.registry }.from([]).to(expected_result)
    end
  end
end
