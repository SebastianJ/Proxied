require "generator_spec"

require "generators/proxied/proxied_generator"

RSpec.describe ::Proxied::Generators::ProxiedGenerator, type: :generator, if: ENV['ADAPTER'] == 'mongoid' do
  root_dir = File.expand_path("../../../tmp/rails_app", __FILE__)
  
  destination root_dir
  
  model = "Proxy"
  
  arguments %W(#{model} --orm=mongoid)

  before :all do
    prepare_destination
    run_generator
  end
  
  it "creates a #{model} model" do
    assert_file "app/models/#{model.downcase}.rb", /class #{model.classify}/, /include Mongoid::Document/, /include ::Proxied::Nosql::ProxyMethods/
  end
  
end
