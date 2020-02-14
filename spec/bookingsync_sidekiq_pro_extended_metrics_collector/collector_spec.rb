require "sidekiq"

RSpec.describe BookingsyncSidekiqProExtendedMetricsCollector::Collector do
  describe "#collect_queues_latency" do
    subject(:collect_queues_latency) do
      described_class.new(datadog_client, configuration).collect_queues_latency
    end

    let(:datadog_client) do
      Class.new do
        attr_reader :registry

        def initialize
          @registry = []
        end

        def gauge(name, value)
          @registry << { name => value }
        end
      end.new
    end
    let(:configuration) do
      BookingsyncSidekiqProExtendedMetricsCollector::Configuration.new.tap do |config|
        config.sidekiq_queues = [:default, :critical]
        config.datadog_namespace = "metrics_collector"
      end
    end
    let(:default_queue) { double(:default_queue, latency: 5.73) }
    let(:critical_queue) { double(:critical_queue, latency: 1.21) }
    let(:expected_result) do
      [
        { "sidekiq.metrics_collector.queue_latency.default" => 5.73 },
        { "sidekiq.metrics_collector.queue_latency.critical" => 1.21 }
      ]
    end

    before do
      allow(Sidekiq::Queue).to receive(:new).with("default") { default_queue }
      allow(Sidekiq::Queue).to receive(:new).with("critical") { critical_queue }
    end

    it "it collects latency metrics for specified queues" do
      expect {
        collect_queues_latency
      }.to change { datadog_client.registry }.from([]).to(expected_result)
    end
  end

  describe "#collect_queue_latency" do
    subject(:collect_queue_latency) do
      described_class.new(datadog_client, configuration).collect_queue_latency("default")
    end

    let(:datadog_client) do
      Class.new do
        attr_reader :registry

        def initialize
          @registry = []
        end

        def gauge(name, value)
          @registry << { name => value }
        end
      end.new
    end
    let(:configuration) do
      BookingsyncSidekiqProExtendedMetricsCollector::Configuration.new.tap do |config|
        config.datadog_namespace = "metrics_collector"
      end
    end
    let(:default_queue) { double(:default_queue, latency: 5.73) }
    let(:expected_result) do
      [
        { "sidekiq.metrics_collector.queue_latency.default" => 5.73 },
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
end
