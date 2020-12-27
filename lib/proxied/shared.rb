module Proxied
  module Shared

    module ClassMethods    
      def get_proxies(protocol: :all, proxy_type: :all, category: nil, country: nil)
        proxies     =   ::Proxy.where(nil)
        proxies     =   proxies.where(protocol: protocol)           if (protocol && !protocol.downcase.to_sym.eql?(:all))
        proxies     =   proxies.where(proxy_type: proxy_type)       if (proxy_type && !proxy_type.downcase.to_sym.eql?(:all))
        proxies     =   proxies.where(category: category)           unless category.to_s.empty?
        proxies     =   proxies.where(country: country.to_s.upcase) unless country.to_s.empty?
      
        return proxies
      end

      # Keep these for compatibility for now, they just wrap the utility functions
      def format_proxy_address(host, port = 80, include_protocol = false)
        ::Proxied::Utilities.format_proxy_address(host: host, port: port, include_protocol: include_protocol)
      end

      def format_proxy_credentials(username, password)
        ::Proxied::Utilities.format_proxy_credentials(username, password)
      end
    end

    module InstanceMethods
      def proxy_address(include_protocol: false)
        case self.auth_mode.to_sym
          when :credentials
            ::Proxied::Utilities.format_proxy_address(host: self.host, port: self.port, protocol: self.protocol, include_protocol: include_protocol)
          when :url
            ::Proxied::Utilities.format_proxy_address(host: self.host, port: self.port, protocol: self.protocol, username: self.username, password: self.password, include_protocol: include_protocol)
        end
      end

      def proxy_credentials
        ::Proxied::Utilities.format_proxy_credentials(self.username, self.password)
      end

      def socks_proxy_credentials
        ::Proxied::Utilities.socks_proxy_credentials(username: self.username, password: self.password)
      end
      
      def proxy_options_for_faraday
        ::Proxied::Utilities.proxy_options_for_faraday(
          host:      self.host,
          port:      self.port,
          protocol:  self.protocol,
          username:  self.username,
          password:  self.password,
          auth_mode: self.auth_mode
        )
      end
      
    end
        
  end
end
