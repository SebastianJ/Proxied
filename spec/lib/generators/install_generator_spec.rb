require "generator_spec"

require "generators/proxied/install_generator"

RSpec.describe ::Proxied::Generators::InstallGenerator, type: :generator do
  root_dir = File.expand_path("../../../tmp/rails_app", __FILE__)
  
  destination root_dir
  
  arguments %w(Proxy)

  before :all do
    prepare_destination
    run_generator
  end
  
  it "creates a configuration initializer" do
    assert_file "config/initializers/proxied.rb", /Proxied.configure do/i
  end
  
end
