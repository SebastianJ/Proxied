::Proxied.configure do |config|
  config.proxy_class                  =   "<%= class_name.camelize.to_s %>" # Must be set to the ActiveRecord or Mongoid model that will be used for managing proxies
  
  config.minimum_successful_attempts  =   1
  config.maximum_failed_attempts      =   10
  
  config.job_queue                    =   :proxies
  
  config.faraday                      =   {
    adapter:    :net_http,
    user_agent: -> { "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_5) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/11.1.1 Safari/605.1.15" },
    verbose:    false
  }
  
  config.http_test                    =   {
    url:      "http://ipinfo.io/ip",
    evaluate: -> (proxy, response) { !(response&.to_s&.strip&.downcase =~ /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/i).nil? },
    timeout:  30,
  }
  
  config.socks_test                   =   {
    hostname: "whois.verisign-grs.com",
    port:     43,
    query:    "=google.com",
    timeout:  30
  }
  
  config.logger                       =   defined?(Rails) ? -> (message) { Rails.logger.info(message) } : -> (message) { puts(message) }
  config.log_level                    =   :info
end
