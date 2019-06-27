lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "konfig/version"

Gem::Specification.new do |spec|
  spec.name = "konfig"
  spec.version = Konfig::VERSION
  spec.authors = ["Khash Sajadi"]
  spec.email = ["khash@sajadi.co.uk"]

  spec.summary = %q{Konfig is a Kubernetes friendly Rails configuration gem}
  spec.homepage = "https://github.com/khash/konfig"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/khash/konfig"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "hash_dot", "~> 2.4"
  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "factory_bot", "~> 5.0"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "rubocop", "~> 0.69"
  spec.add_development_dependency "rubocop-performance", "~> 1.3"
  spec.add_development_dependency "rufo", "~> 0.7"
  spec.add_development_dependency "byebug"
end
