# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rf_rgb/version"

Gem::Specification.new do |spec|
  spec.name          = "rf_rgb"
  spec.version       = RfRgb::VERSION
  spec.authors       = ["mpd"]
  spec.email         = ["mpd@jesters-court.net"]

  spec.summary       = %q{Some classes to interact with Topre Realforce RGB keyboards.}
  spec.description   = %q{Some classes to allow for read and writing key colors and actuation heights on Topre Realforce RGB keyboards}
  spec.homepage      = "https://github.com/xxx/rf_rgb"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "libusb", "~> 0.6"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
