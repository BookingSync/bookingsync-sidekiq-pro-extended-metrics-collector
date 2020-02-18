RSpec.describe BookingsyncSidekiqProExtendedMetricsCollector::SidekiqRetryMiddleware do
  describe "#call" do
    subject(:call) { described_class.new.call(worker, job, queue) {} }

    let(:worker) { double(:worker) }
    let(:job) { double(:job) }
    let(:queue) { double(:queue) }

    it "collects retry count metric" do
      expect(BookingsyncSidekiqProExtendedMetricsCollector).to receive(:collect_retry_count)

      call
    end
  end
end
