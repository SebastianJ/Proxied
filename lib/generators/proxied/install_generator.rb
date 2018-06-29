# frozen_string_literal: true

require "rails/generators/base"

module Proxied
  module Generators
    class InstallGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a Proxied initializer for your application."

      def copy_initializer
        template "proxied.rb", "config/initializers/proxied.rb"
      end
      
    end
  end
end
