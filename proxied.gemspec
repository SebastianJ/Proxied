
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "proxied/version"

Gem::Specification.new do |spec|
  spec.name          = "proxied"
  spec.version       = Proxied::VERSION
  spec.authors       = ["Sebastian"]
  spec.email         = ["sebastian.johnsson@gmail.com"]

  spec.summary       = %q{Proxied is a proxy management gem for Ruby/Rails.}
  spec.description   = %q{Manage HTTP(S) and SOCKS proxies for Rails apps. Supports ActiveRecord and Mongoid as ORM.}
  spec.homepage      = "https://github.com/SebastianJ/proxied"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  
  spec.add_dependency "faraday",                    ">= 0.15.4"
  spec.add_dependency "net-ssh",                    ">= 5.1"
  
  spec.add_development_dependency "bundler",        ">= 1.17.2"
  spec.add_development_dependency "rake",           ">= 12.3.2"
  spec.add_development_dependency "appraisal",      ">= 2.2.0"
  
  spec.add_development_dependency "virtus",         ">= 1.0"
  
  spec.add_development_dependency "rspec-rails",    ">= 3.8.2"
  spec.add_development_dependency "rspec-core",     ">= 3.8"
  spec.add_development_dependency "rspec-expectations", ">= 3.8.2"
  spec.add_development_dependency "rspec-mocks",    ">= 3.8"
  spec.add_development_dependency "rspec-support",  ">= 3.8"
  spec.add_development_dependency "generator_spec", ">= 0.9.4"
  
  spec.add_development_dependency "rdoc",           ">= 6.1.1"
  spec.add_development_dependency "vcr",            ">= 4.0"
  spec.add_development_dependency "webmock",        ">= 3.5.1"
  
  spec.add_development_dependency "pry",            ">= 0.12.2"  
end
