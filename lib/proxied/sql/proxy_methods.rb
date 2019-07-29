module Proxied
  module Sql
    
    module ProxyMethods
    
      def self.included(base)
        base.extend(::Proxied::Shared::ClassMethods)
        base.extend(ClassMethods)
        
        base.include(::Proxied::Shared::InstanceMethods)
      end

      module ClassMethods
        def should_be_checked(mode: :synchronous, protocol: :all, proxy_type: :all, category: nil, date: Time.now, limit: nil, maximum_failed_attempts: 10)
          proxies     =   get_proxies(protocol: protocol, proxy_type: proxy_type, category: category)
          proxies     =   proxies.where(checkable: true)
          proxies     =   proxies.where(asyncable: true) if mode.to_sym.eql?(:asynchronous)
          proxies     =   proxies.where(["(last_checked_at IS NULL OR last_checked_at < ?)", date])
          proxies     =   proxies.where(["failed_attempts <= ?", maximum_failed_attempts])
          proxies     =   proxies.order("valid_proxy ASC, failed_attempts ASC, last_checked_at ASC")
          proxies     =   proxies.limit(limit) if limit && !limit.zero?
        
          return proxies
        end
      
        def get_valid_proxies(protocol: :all, proxy_type: :all, category: nil, maximum_failed_attempts: nil)
          proxies     =   get_proxies(protocol: protocol, proxy_type: proxy_type, category: category)
          proxies     =   proxies.where(["valid_proxy = ? AND last_checked_at IS NOT NULL", true])
          proxies     =   proxies.where(["failed_attempts <= ?", maximum_failed_attempts]) if maximum_failed_attempts

          return proxies
        end
      
        def get_random_proxy(protocol: :all, proxy_type: :all, category: nil, maximum_failed_attempts: nil)
          proxies     =   get_valid_proxies(protocol: protocol, proxy_type: proxy_type, category: category, maximum_failed_attempts: maximum_failed_attempts)
          proxies     =   yield(proxies) if block_given?
        
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
        
          proxies     =   proxies.order(Arel.sql(order_clause))
        
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
