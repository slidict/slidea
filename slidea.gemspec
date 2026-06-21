# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "slidea"
  spec.version = "0.1.0"
  spec.summary = "Generate presentation-ready slides from a simple conversation."
  spec.description = "Slidea is a Ruby CLI for turning rough ideas into presentation-ready Markdown slides."
  spec.authors = ["Slidea contributors"]
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1"

  spec.files = Dir["lib/**/*.rb", "bin/*", "README.md"]
  spec.bindir = "bin"
  spec.executables = ["slidea"]
  spec.require_paths = ["lib"]
end
