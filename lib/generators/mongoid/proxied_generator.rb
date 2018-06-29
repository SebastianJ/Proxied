# frozen_string_literal: true

require "rails/generators/named_base"
require "generators/proxied/orm_helpers"

module Mongoid
  module Generators
    class ProxiedGenerator < Rails::Generators::NamedBase
      include Proxied::Generators::OrmHelpers

      def generate_model
        invoke "mongoid:model", [name] unless model_exists? && behavior == :invoke
      end
      
      def inject_proxied_content
        inject_into_file model_path, model_contents, after: inject_after_pattern(:mongoid) if model_exists?
      end

      def model_contents
<<RUBY
  include Mongoid::Timestamps
  
  # Fields
  field :host, type: String
  field :port, type: Integer
  
  field :username, type: String
  field :password, type: String
  
  field :protocol, type: String, default: :http
  field :proxy_type, type: String, default: :public
  field :category, type: String
  
  field :valid_proxy, type: Boolean, default: false
  field :successful_attempts, type: Integer, default: 0
  field :failed_attempts, type: Integer, default: 0
  
  field :last_checked_at, type: DateTime
  
  # Validations
  validates :host, presence: true, uniqueness: {scope: :port}
  
  # Indexes
  index({ host: 1, port: 1 }, { unique: true, drop_dups: true })
  index({ protocol: 1, proxy_type: 1, valid_proxy: -1, failed_attempts: 1 })
  index({ valid_proxy: 1 })
  
  # Methods
  include ::Proxied::Nosql::ProxyMethods
RUBY
      end
    end
  end
end
