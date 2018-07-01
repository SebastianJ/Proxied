module Proxied
  class Seeder
    
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
        query                       =   {
          host:       proxy_item[:host]&.to_s&.strip,
          port:       proxy_item[:port]&.to_s&.strip&.to_i
        }
    
        parsed                      =   {
          protocol:   proxy_item.fetch(:protocol, "http")&.to_s&.strip&.downcase,
          proxy_type: proxy_item.fetch(:type, :private)&.to_s&.strip,
          category:   proxy_item.fetch(:category, nil)&.to_s&.strip&.downcase,
          country:    proxy_item.fetch(:country, nil)&.to_s&.strip&.downcase,
          city:       proxy_item.fetch(:city, nil)&.to_s&.strip&.downcase,
          username:   proxy_item.fetch(:username, nil)&.to_s&.strip,
          password:   proxy_item.fetch(:password, nil)&.to_s&.strip
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
