
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

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  
  spec.add_dependency "faraday",                    "~> 0.15.2"
  spec.add_dependency "net-ssh",                    "~> 5.0.2"
  
  spec.add_development_dependency "bundler",        "~> 1.16.2"
  spec.add_development_dependency "rake",           "~> 12.3.1"
  spec.add_development_dependency "appraisal",      "~> 2.2"
  
  spec.add_development_dependency "virtus",         "~> 1.0", ">= 1.0.5"
  
  spec.add_development_dependency "rspec-rails",    '~> 3.7', '>= 3.7.2'
  spec.add_development_dependency "rspec-core",     '~> 3.7', '>= 3.7.1'
  spec.add_development_dependency "rspec-expectations", '~> 3.7'
  spec.add_development_dependency "rspec-mocks",    '~> 3.7'
  spec.add_development_dependency "rspec-support",  '~> 3.7', '>= 3.7.1'
  spec.add_development_dependency "generator_spec", "~> 0.9.4"
  
  spec.add_development_dependency "rdoc",           "~> 6.0.4"
  spec.add_development_dependency "vcr",            "~> 4.0"
  spec.add_development_dependency "webmock",        "~> 3.4.2"
  
  spec.add_development_dependency "pry",            "~> 0.11.3"  
end
