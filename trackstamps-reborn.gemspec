require_relative "lib/trackstamps/reborn/version"

Gem::Specification.new do |spec|
  spec.name = "trackstamps-reborn"
  spec.version = Trackstamps::Reborn::VERSION
  spec.authors = ["Dušan"]
  spec.email = ["dusan.uveric@mitigate.dev"]

  spec.summary = ""
  spec.homepage = "https://github.com/uvera/trackstamps-reborn"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/uvera/trackstamps-reborn/issues",
    "changelog_uri" => "https://github.com/uvera/trackstamps-reborn/releases",
    "source_code_uri" => "https://github.com/uvera/trackstamps-reborn",
    "homepage_uri" => spec.homepage,
    "rubygems_mfa_required" => "true"
  }

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob(%w[LICENSE.txt README.md {exe,lib}/**/*]).reject { |f| File.directory?(f) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency 'rails', '~> 5.2'
end
