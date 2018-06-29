require 'rails'

module Proxied
  class Railtie < Rails::Railtie
    
    rake_tasks do
      Dir[File.join(File.dirname(__FILE__), '../tasks/*.rake')].each { |ext| load ext }
    end
    
  end
end
