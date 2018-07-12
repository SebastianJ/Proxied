RSpec.configure do |config|
  config.before(:each) do
    # The famous singleton problem
    Proxied.configure do |config|
      config.proxy_class  =   "TestProxy"
      config.logger       =   -> (message) { puts(message) }
    end
  end
end
