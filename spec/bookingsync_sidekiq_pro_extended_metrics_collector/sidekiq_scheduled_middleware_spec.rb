RSpec.describe BookingsyncSidekiqProExtendedMetricsCollector::SidekiqScheduledMiddleware do
  describe "#call" do
    subject(:call) { described_class.new.call(worker, job, queue) {} }

    let(:worker) { double(:worker) }
    let(:job) { double(:job) }
    let(:queue) { double(:queue) }

    it "collects scheduled count metric" do
      expect(BookingsyncSidekiqProExtendedMetricsCollector).to receive(:collect_scheduled_count)

      call
    end
  end
end
