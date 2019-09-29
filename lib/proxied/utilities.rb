module Proxied
  class Utilities
    class << self
      
      def format_proxy_address(host:, port: 80, username: nil, password: nil, include_http: false)
        address                   =   "#{host.strip}:#{port}"
        address                   =   "#{format_proxy_credentials(username, password)}@#{address}" if !username.to_s.empty? && !password.to_s.empty?
        address                   =   (include_http && !address.start_with?("http://")) ? "http://#{address}" : address
        
        return address
      end

      def format_proxy_credentials(username, password)
        return "#{encode_credential(username)}:#{encode_credential(password)}"
      end
      
      def encode_credential(credential)
        CGI::escape(credential)
      end
      
      def socks_proxy_credentials(username: nil, password: nil)
        credentials               =   {}
        
        credentials[:user]        =   username if !username.to_s.empty?
        credentials[:password]    =   password if !password.to_s.empty?

        return credentials
      end
      
      def proxy_options_for_faraday(host:, port: 80, username: nil, password: nil, auth_mode: :credentials)
        proxy_options             =   {}
        username                  =   encode_credential(username)
        password                  =   encode_credential(password)
        
        options                   =   {host: host, port: port, include_http: true}
        options[:username]        =   username if !username.to_s.empty? && auth_mode&.to_sym&.eql?(:basic_auth)
        options[:password]        =   password if !password.to_s.empty? && auth_mode&.to_sym&.eql?(:basic_auth)
        
        proxy_options[:uri]       =   format_proxy_address(options)
        proxy_options[:user]      =   username if !username.to_s.empty? && auth_mode&.to_sym&.eql?(:credentials)
        proxy_options[:password]  =   password if !password.to_s.empty? && auth_mode&.to_sym&.eql?(:credentials)
    
        return proxy_options
      end
      
    end
  end
end
