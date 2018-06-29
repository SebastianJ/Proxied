# frozen_string_literal: true

require "rails/generators/active_record"
require "generators/proxied/orm_helpers"

module ActiveRecord
  module Generators
    class ProxiedGenerator < ActiveRecord::Generators::Base
      class_option :primary_key_type, type: :string, desc: "The type for primary key"

      include Proxied::Generators::OrmHelpers
      source_root File.expand_path("../templates", __FILE__)

      def copy_proxy_migration
        migration_template "migration.rb", "#{migration_path}/proxied_create_#{table_name}.rb", migration_version: migration_version
      end

      def generate_model
        invoke "active_record:model", [name], migration: false unless model_exists? && behavior == :invoke
      end
      
      def inject_proxied_content
        content = model_contents

        class_path = if namespaced?
          class_name.to_s.split("::")
        else
          [class_name]
        end

        indent_depth = class_path.size - 1
        content = content.split("\n").map { |line| "  " * indent_depth + line } .join("\n") << "\n"

        inject_into_class(model_path, class_path.last, content) if model_exists?
      end
      
      def model_contents
<<RUBY
  include ::Proxied::Sql::ProxyMethods
RUBY
      end

      def rails5?
        Rails.version.start_with? '5'
      end

      def postgresql?
        config = ActiveRecord::Base.configurations[Rails.env]
        config && config['adapter'] == 'postgresql'
      end

     def migration_version
       if rails5?
         "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
       end
     end

     def primary_key_type
       primary_key_string if rails5?
     end

     def primary_key_string
       key_string = options[:primary_key_type]
       ", id: :#{key_string}" if key_string
     end
    end
  end
end
