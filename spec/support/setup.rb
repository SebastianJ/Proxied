RSpec.configure do |config|
  config.before(:each) do
    # The famous singleton problem
    Proxied.configure do |config|
      config.proxy_class  =   "TestProxy"
      config.logger       =   -> (message) { puts(message) }
    end
  end
end

require "yaml"

def load_proxies(type = nil)
  proxies               =   nil
  path                  =   File.join(File.dirname(__FILE__), "files/proxies.yml")
  
  if ::File.exists?(path)
    proxies             =   YAML.load_file(path)
    proxies             =   proxies.fetch(type, []) if type
  end
  
  return proxies
end
