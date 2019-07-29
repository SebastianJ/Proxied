::Proxied.configure do |config|
  config.proxy_class                  =   "<%= class_name.camelize.to_s %>" # Must be set to the ActiveRecord or Mongoid model that will be used for managing proxies
  
  config.minimum_successful_attempts  =   1
  config.maximum_failed_attempts      =   10
  
  config.job_queue                    =   :proxies
  
  config.http_test                    =   {
    url:      "http://ipinfo.io/ip",
    evaluate: -> (proxy, response) { response.to_s.strip.eql?(proxy.ip_address.strip) },
    timeout:  10,
  }
  
  config.socks_test                   =   {
    hostname: "whois.verisign-grs.com",
    port:     43,
    query:    "=google.com",
    timeout:  10
  }
end
