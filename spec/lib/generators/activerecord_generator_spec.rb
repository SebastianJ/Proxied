require "generator_spec"

require "generators/proxied/proxied_generator"

RSpec.describe ::Proxied::Generators::ProxiedGenerator, type: :generator, if: ENV['ADAPTER'] == 'active_record' do
  root_dir = File.expand_path("../../../tmp/rails_app", __FILE__)
  
  destination root_dir
  
  model = "Proxy"
  
  arguments %W(#{model} --orm=active_record)

  before :all do
    prepare_destination
    run_generator
  end
  
  it "creates a #{model} model" do
    assert_migration "db/migrate/proxied_create_#{model.tableize}.rb", /def change/
    assert_file "app/models/#{model.downcase}.rb", /class #{model} < ApplicationRecord/, /include ::Proxied::Sql::ProxyMethods/
  end
  
end
