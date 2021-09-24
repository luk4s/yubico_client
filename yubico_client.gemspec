# frozen_string_literal: true

require_relative "lib/yubico_client/version"

Gem::Specification.new do |spec|
  spec.name          = "yubico_client"
  spec.version       = YubicoClient::VERSION
  spec.authors       = ["Lukáš Pokorný"]
  spec.email         = ["pokorny@luk4s.cz"]

  spec.summary       = "Ruby client for Yubikey OTP"
  spec.description   = "With on rest-client verify OTP against yubico OTP cloud"
  spec.homepage      = "https://github.com/luk4s/yubico_client"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client", "~> 2.1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
