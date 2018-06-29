module Proxied
  module Sql
    
    module ProxyMethods
    
      def self.included(base)
        base.send :extend ::Proxied::Shared::ClassMethods
        base.send :extend, ClassMethods
        
        base.send :include ::Proxied::Shared::InstanceMethods
      end

      module ClassMethods
        def should_be_checked(protocol: :all, proxy_type: :all, date: Time.now, limit: 10, maximum_failed_attempts: 10)
          proxies     =   get_proxies_for_protocol_and_proxy_type(protocol, proxy_type)
          proxies     =   proxies.where(["(last_checked_at IS NULL OR last_checked_at < ?)", date])
          proxies     =   proxies.where(["failed_attempts <= ?", maximum_failed_attempts])
          proxies     =   proxies.order("valid_proxy ASC, failed_attempts ASC, last_checked_at ASC")
          proxies     =   proxies.limit(limit)
        
          return proxies
        end
      
        def get_valid_proxies(protocol: :all, proxy_type: :all, maximum_failed_attempts: nil)
          proxies     =   get_proxies_for_protocol_and_proxy_type(protocol, proxy_type)
          proxies     =   proxies.where(["valid_proxy = ? AND last_checked_at IS NOT NULL", true])
          proxies     =   proxies.where(["failed_attempts <= ?", maximum_failed_attempts]) if maximum_failed_attempts

          return proxies
        end
      
        def get_random_proxy(protocol: :all, proxy_type: :all, maximum_failed_attempts: nil)
          proxies     =   get_valid_proxies(protocol: protocol, proxy_type: proxy_type, maximum_failed_attempts: maximum_failed_attempts)
        
          order_clause = case ActiveRecord::Base.connection.class.name
            when "ActiveRecord::ConnectionAdapters::MysqlAdapter", "ActiveRecord::ConnectionAdapters::Mysql2Adapter"
              "RAND() DESC"
            when "ActiveRecord::ConnectionAdapters::PostgreSQLAdapter"
              "RANDOM() DESC"
            when "ActiveRecord::ConnectionAdapters::SQLite3Adapter"
              "RANDOM() DESC"
            else
              "RAND() DESC"
          end
        
          proxies     =   proxies.order(order_clause)
        
          proxy       =   nil
        
          uncached do
            proxy     =   proxies.limit(1).first
          end

          return proxy
        end
      end
    
    end
    
  end
end
