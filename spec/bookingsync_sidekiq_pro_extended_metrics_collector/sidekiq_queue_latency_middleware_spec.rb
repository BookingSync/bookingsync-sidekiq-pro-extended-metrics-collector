RSpec.describe BookingsyncSidekiqProExtendedMetricsCollector::SidekiqQueueLatencyMiddleware do
  describe "#call" do
    subject(:call) { described_class.new.call(worker, job, queue) {} }

    let(:worker) { double(:worker) }
    let(:job) { double(:job) }
    let(:queue) { "default" }

    it "collects latency metric for that queue" do
      expect(BookingsyncSidekiqProExtendedMetricsCollector).to receive(:collect_queue_latency).with(queue)

      call
    end
  end
end
