module Proxied
  module Jobs
    class CheckProxiesJob
      include ::Sidekiq::Worker
      sidekiq_options queue: :proxies

      def perform(protocol = :all, proxy_type = :all, mode = :synchronous)
        ::Proxied::Checker.new.check_proxies(protocol: protocol.to_sym, proxy_type: proxy_type.to_sym, mode: mode.to_sym)
      end
    end
  end
end
