RSpec.describe BookingsyncSidekiqProExtendedMetricsCollector::Configuration do
  describe "datadog_host" do
    subject(:config) { described_class.new }

    it "is an attr accessor" do
      expect {
        config.datadog_host = :datadog_host
      }.to change { config.datadog_host }.from(nil).to(:datadog_host)
    end
  end

  describe "datadog_port" do
    subject(:config) { described_class.new }

    it "is an attr accessor" do
      expect {
        config.datadog_port = :datadog_port
      }.to change { config.datadog_port }.from(nil).to(:datadog_port)
    end
  end

  describe "datadog_namespace" do
    subject(:config) { described_class.new }

    it "is an attr accessor" do
      expect {
        config.datadog_namespace = :datadog_namespace
      }.to change { config.datadog_namespace }.from(nil).to(:datadog_namespace)
    end
  end

  describe "sidekiq_queues" do
    subject(:config) { described_class.new }

    it "is an attr accessor with a default as an empty array" do
      expect {
        config.sidekiq_queues = [:default]
      }.to change { config.sidekiq_queues }.from([]).to([:default])
    end
  end
end
