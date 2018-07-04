module Proxied
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= ::Proxied::Configuration.new
  end

  def self.reset
    @configuration = ::Proxied::Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end

# Gems
require "faraday"
require "net/ssh/proxy/socks5"

# Standard library
require "socket"

# Gem
require "proxied/version"

require "proxied/configuration"
require "proxied/logger"
require "proxied/utilities"

require "proxied/shared"
require "proxied/sql/proxy_methods" if defined?(ActiveRecord)
require "proxied/nosql/proxy_methods" if defined?(Mongoid)

require "proxied/checker"
require "proxied/importer"

if defined?(Sidekiq)
  require "proxied/jobs/check_proxies_job"
  require "proxied/jobs/check_proxy_job"
end

require "proxied/railtie" if defined?(Rails)
