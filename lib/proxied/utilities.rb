module Proxied
  class Utilities
    
    class << self
      
      def format_proxy_address(host:, port: 80, include_http: false)
        address                   =   "#{host}:#{port}"
        address                   =   "http://#{address}" if include_http && !address.start_with?("http://")
        
        return address
      end

      def format_proxy_credentials(username, password)
        return "#{username}:#{password}"
      end
      
      def socks_proxy_credentials(username: nil, password: nil)
        credentials               =   {}
        
        credentials[:user]        =   username if !username.to_s.empty?
        credentials[:password]    =   password if !password.to_s.empty?

        return credentials
      end
      
      def proxy_options_for_faraday(host:, port:, username: nil, password: nil)
        proxy_options             =   {}
    
        proxy_options[:uri]       =   format_proxy_address(host: host, port: port, include_http: true)
        proxy_options[:user]      =   username if !username.to_s.empty?
        proxy_options[:password]  =   password if !password.to_s.empty?
    
        return proxy_options
      end
      
    end
    
  end
end
