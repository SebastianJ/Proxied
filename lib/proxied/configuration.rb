module Proxied
  class Configuration
    attr_accessor :proxy_class
    attr_accessor :minimum_successful_attempts, :maximum_failed_attempts
    attr_accessor :faraday
    attr_accessor :http_test, :socks_test
    attr_accessor :job_queue
    attr_accessor :logger
  
    def initialize      
      self.proxy_class                  =   nil # Must be set to the ActiveRecord or Mongoid model that will be used for managing proxies
      
      self.minimum_successful_attempts  =   1
      self.maximum_failed_attempts      =   10
      
      self.faraday          =   {
        adapter:    :net_http,
        user_agent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_5) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.1.1 Safari/605.1.15",
        verbose:    false
      }
      
      self.http_test        =   {
        url:      "http://ipinfo.io/ip",
        evaluate: -> (proxy, response) { !(response&.to_s&.strip&.downcase =~ /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/i).nil? },
        timeout:  30,
      }
      
      self.socks_test       =   {
        hostname: "whois.verisign-grs.com",
        port:     43,
        query:    "=google.com",
        timeout:  30
      }
      
      self.job_queue        =   :proxies
      
      self.logger           =   defined?(Rails) ? -> (message) { Rails.logger.info(message) } : -> (message) { puts(message) }
    end
    
    def verbose_faraday?
      self.faraday.fetch(:verbose, false)
    end
  
  end
end
