module Proxied
  module Shared

    module ClassMethods    
      def get_proxies_for_protocol_and_proxy_type(protocol, proxy_type)
        proxies     =   ::Proxy.where(nil)
        proxies     =   proxies.where(protocol: protocol)     if (protocol && !protocol.downcase.to_sym.eql?(:all))
        proxies     =   proxies.where(proxy_type: proxy_type) if (proxy_type && !proxy_type.downcase.to_sym.eql?(:all))
      
        return proxies
      end

      def format_proxy_address(proxy_host, proxy_port = 80, include_http = false)
        proxy_address = "#{proxy_host}:#{proxy_port}"
        proxy_address.insert(0, "http://") if (include_http && !proxy_address.start_with?("http://"))
        return proxy_address
      end

      def format_proxy_credentials(username, password)
        return "#{username}:#{password}"
      end
    end

    module InstanceMethods
      def proxy_address(include_http = false)
        return self.class.format_proxy_address(self.host, self.port, include_http)
      end

      def proxy_credentials
        return self.class.format_proxy_credentials(self.username, self.password)
      end

      def socks_proxy_credentials
        credentials               =   {}
        
        credentials[:user]        =   self.username if !self.username.to_s.empty?
        credentials[:password]    =   self.password if !self.password.to_s.empty?

        return credentials
      end
      
      def proxy_options_for_faraday
        proxy_options             =   {}
    
        proxy_options[:uri]       =   self.class.format_proxy_address(self.host, self.port, true)
        proxy_options[:user]      =   self.username if !self.username.to_s.empty?
        proxy_options[:password]  =   self.password if !self.password.to_s.empty?
    
        return proxy_options
      end
    end
        
  end
end
