module Proxied
  class Logger
    class << self
      
      def info(message)
        log(message) if ::Proxied.configuration.log_level.to_sym.eql?(:info)
      end
    
      def debug(message)
        log(message) if ::Proxied.configuration.log_level.to_sym.eql?(:debug)
      end
    
      def self.log(message)
        ::Proxied.configuration.logger.call(message)
      end
      
    end
  end
end
