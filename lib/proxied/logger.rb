module Proxied
  class Logger
    
    def self.log(message)
      ::Proxied.configuration.logger.call(message)
    end
      
  end
end
