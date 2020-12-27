module Proxied
  class Configuration
    attr_accessor :proxy_class
    attr_accessor :minimum_successful_attempts, :maximum_failed_attempts
    attr_accessor :job_queue
    attr_accessor :logger, :log_level
    attr_accessor :faraday
    attr_accessor :http_test, :socks_test
    
    def initialize
      # The ActiveRecord or Mongoid model that will be used for managing proxies - Must be set otherwise the gem won't work!
      self.proxy_class                  =   nil
      
      # The minimum successful attempts and maximum failed attempts before a proxy shouldn't be considered valid anymore
      self.minimum_successful_attempts  =   1
      self.maximum_failed_attempts      =   10
      
      # The queue that Sidekiq/ActiveJob will use to check proxies
      self.job_queue        =   :proxies
      
      # Log settings - if Rails is available it will log to the Rails log, otherwise just puts
      self.logger           =   defined?(Rails) ? -> (message) { Rails.logger.info(message) } : -> (message) { puts(message) }
      self.log_level        =   :info
      
      # The settings below are for configuring the proxy checker service
      self.faraday          =   {
        adapter:    :net_http,
        user_agent: -> { "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.2 Safari/605.1.15" },
        verbose:    false
      }
      
      self.http_test        =   {
        url:      "https://ipinfo.io/ip",
        evaluate: -> (proxy, response) { !(response&.to_s&.strip&.downcase =~ /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/i).nil? },
        timeout:  30,
      }
      
      self.socks_test       =   {
        hostname: "whois.verisign-grs.com",
        port:     43,
        query:    "=google.com",
        timeout:  30
      }
    end
    
    def verbose_faraday?
      self.faraday.fetch(:verbose, false)
    end
  
  end
end
