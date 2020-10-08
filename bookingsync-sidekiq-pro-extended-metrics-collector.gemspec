lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bookingsync_sidekiq_pro_extended_metrics_collector/version"

Gem::Specification.new do |spec|
  spec.name          = "bookingsync-sidekiq-pro-extended-metrics-collector"
  spec.version       = BookingsyncSidekiqProExtendedMetricsCollector::VERSION
  spec.authors       = ["Karol Galanciak"]
  spec.email         = ["karol@bookingsync.com"]

  spec.summary       = %q{Gem for collecting extended metrics for Sidekiq Pro.}
  spec.description   = %q{Gem for collecting extended metrics for Sidekiq Pro.}
  spec.homepage      = "https://github.com/BookingSync/bookingsync-sidekiq-pro-extended-metrics-collector"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/BookingSync/bookingsync-sidekiq-pro-extended-metrics-collector"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "dogstatsd-ruby", "~> 4"
  spec.add_dependency "sidekiq", ">= 5"
end
