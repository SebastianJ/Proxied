::Proxied.configure do |config|
  config.proxy_class                  =   <%= class_name.camelize.to_s %> # Must be set to the ActiveRecord or Mongoid model that will be used for managing proxies
  
  config.minimum_successful_attempts  =   1
  config.maximum_failed_attempts      =   10
  
  config.job_queue                    =   :proxies
end
