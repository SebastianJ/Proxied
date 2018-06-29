require "virtus"

class Proxy
  include Virtus.model
  
  attribute :host,                String
  attribute :port,                Integer
  attribute :username,            String
  attribute :password,            String
  attribute :protocol,            String
  attribute :proxy_type,          String
  attribute :category,            String
  attribute :valid_proxy,         Boolean
  attribute :successful_attempts, Integer
  attribute :failed_attempts,     Integer
  attribute :last_checked_at,     DateTime
  
  extend  ::Proxied::Shared::ClassMethods
  include ::Proxied::Shared::InstanceMethods
end   
