module Proxied
  module Nosql
    
    module ProxyMethods
    
      def self.included(base)
        base.send :extend ::Proxied::Shared::ClassMethods
        base.send :extend, ClassMethods
        
        base.send :include ::Proxied::Shared::InstanceMethods
      end

      module ClassMethods
        def should_be_checked(mode: :synchronous, protocol: :all, proxy_type: :all, category: nil, date: Time.now, limit: nil, maximum_failed_attempts: 10)
          proxies     =   get_proxies(protocol: protocol, proxy_type: proxy_type, category: category)
          
          proxies     =   proxies.where(async_supported: true) if mode.to_sym.eql?(:asynchronous)
  
          proxies     =   proxies.any_of(
            {:last_checked_at.exists => false},
            {:last_checked_at.ne => nil},
            {:last_checked_at.exists => true, :last_checked_at.ne => nil, :last_checked_at.lt => date}
          )
  
          proxies     =   proxies.any_of(
            {:failed_attempts.exists => false},
            {:failed_attempts.in => ["", nil]},
            {:failed_attempts.exists => true, :failed_attempts.nin => ["", nil], :failed_attempts.lte => maximum_failed_attempts}
          )
  
          proxies     =   proxies.order_by([[:valid_proxy, :asc], [:failed_attempts, :asc], [:last_checked_at, :asc]])
          proxies     =   proxies.limit(limit) if limit && !limit.zero?
  
          return proxies
        end
      
        def get_valid_proxies(protocol: :all, proxy_type: :all, category: nil, maximum_failed_attempts: nil)
          proxies     =   get_proxies(protocol: protocol, proxy_type: proxy_type, category: category)
          proxies     =   proxies.where(valid_proxy: true)
          proxies     =   proxies.where(:failed_attempts.lte => maximum_failed_attempts) if maximum_failed_attempts
        end
      
        def get_random_proxy(protocol: :all, proxy_type: :all, category: nil, maximum_failed_attempts: nil, retries: 3)
          proxies     =   get_valid_proxies(protocol: protocol, proxy_type: proxy_type, category: category, maximum_failed_attempts: maximum_failed_attempts)
          proxies     =   yield(proxies) if block_given?
          
          proxy       =   nil
          
          begin
            proxy     =   proxies.skip(rand(proxies.count)).first
          
          rescue StandardError
            retries  -=   1
            retry if retries > 0
          end
          
          return proxy
        end
      end
    
    end
    
  end
end
