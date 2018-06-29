# frozen_string_literal: true

require "rails/generators/named_base"

module Proxied
  module Generators
    class ProxiedGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      
      class_option :orm, type: :string, default: "active_record"

      namespace "proxied"
      source_root File.expand_path("../templates", __FILE__)

      desc "Generates a model with the given NAME (if one does not exist) with devise " \
           "configuration plus a migration file and devise routes."

      hook_for :orm, required: true

    end
  end
end
