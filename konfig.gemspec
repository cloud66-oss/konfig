lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "konfig/version"

Gem::Specification.new do |spec|
  spec.name = "rb-konfig"
  spec.version = Konfig::VERSION
  spec.authors = ["Khash Sajadi"]
  spec.email = ["hello@cloud66.com"]

  spec.summary = %q{Konfig is a Kubernetes friendly Rails configuration gem}
  spec.homepage = "https://github.com/cloud66-oss/konfig/"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/cloud66-oss/konfig/"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 4"
  spec.add_dependency "dry-schema", "~> 1.3"
  spec.add_dependency "thor", "~> 0.20"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "factory_bot", "~> 5.0"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "rubocop", "~> 0.69"
  spec.add_development_dependency "rubocop-performance", "~> 1.3"
  spec.add_development_dependency "rufo", "~> 0.7"
  spec.add_development_dependency "byebug", "~> 11.0"
end
