lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "process_observer/version"

Gem::Specification.new do |spec|
  spec.name          = "process_observer"
  spec.version       = ProcessObserver::VERSION
  spec.authors       = ["Fizvlad"]
  spec.email         = ["fizvlad@mail.ru"]

  spec.summary       = "Small gem to get info about current list of processes."
  spec.homepage      = "https://github.com/fizvlad/process-observer-rb"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/fizvlad/process-observer-rb"
  spec.metadata["changelog_uri"] = "https://github.com/fizvlad/process-observer-rb/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.test_files    = Dir[ "test/**/test_*.rb" ]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
