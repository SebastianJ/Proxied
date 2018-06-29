# frozen_string_literal: true

module Proxied
  module Generators
    module OrmHelpers

      private
      
      def inject_after_pattern(orm = :active_record)
        if orm == :active_record
          /class #{table_name.camelize}\n|class #{table_name.camelize} .*\n|class #{table_name.demodulize.camelize}\n|class #{table_name.demodulize.camelize} .*\n/
        else
          /include Mongoid::Document\n|include Mongoid::Document .*\n/
        end
      end
      
      def model_exists?
        File.exist?(File.join(destination_root, model_path))
      end

      def migration_path
        if Rails.version >= '5.0.3'
          db_migrate_path
        else
          @migration_path ||= File.join("db", "migrate")
        end
      end

      def model_path
        @model_path ||= File.join("app", "models", "#{file_path}.rb")
      end
    end
  end
end
