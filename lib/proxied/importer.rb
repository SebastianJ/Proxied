module Proxied
  class Importer
    
    # Expected format:
    # {
    #   host
    #   port
    #   protocol (http,socks)
    #   proxy_type (private,public)
    #   category
    #   country
    #   city
    #   username
    #   password
    # }
    
    def self.import(proxies)
      proxies.each do |proxy_item|
        host                        =   proxy_item[:host]&.to_s&.strip&.downcase
        port                        =   proxy_item[:port]&.to_s&.strip&.to_i
        ip_address                  =   proxy_item.fetch(:ip_address, host)&.to_s&.strip&.downcase
        
        query                       =   {
          host:            host,
          port:            port
        }
    
        parsed                      =   {
          ip_address:      ip_address,
          protocol:        proxy_item.fetch(:protocol, "http")&.to_s&.strip&.downcase,
          proxy_type:      proxy_item.fetch(:type, :private)&.to_s&.strip,
          category:        proxy_item.fetch(:category, nil)&.to_s&.strip&.downcase,
          country:         proxy_item.fetch(:country, nil)&.to_s&.strip&.upcase,
          city:            proxy_item.fetch(:city, nil)&.to_s&.strip&.downcase,
          username:        proxy_item.fetch(:username, nil)&.to_s&.strip,
          password:        proxy_item.fetch(:password, nil)&.to_s&.strip,
          auth_mode:       proxy_item.fetch(:auth_mode, :credentials)&.to_s&.strip,
          async_supported: proxy_item.fetch(:async_supported, true)&.to_s&.strip,
        }.merge(query)
    
        proxy                       =   ::Proxied.configuration.proxy_class.constantize.where(query).first || ::Proxied.configuration.proxy_class.constantize.new
    
        parsed.each do |key, value|
          proxy.send("#{key}=", value)
        end
    
        proxy.last_checked_at       =   Time.now
        proxy.valid_proxy           =   true
        proxy.successful_attempts   =   1
    
        proxy.save
      end
    end
    
  end
end
