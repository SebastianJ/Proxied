module Proxied
  module Jobs
    class CheckProxiesJob
      include ::Sidekiq::Worker
      sidekiq_options queue: ::Proxied.configuration.job_queue

      def perform(protocol = :all, proxy_type = :all, mode = :synchronous)
        ::Proxied::Checker.new.check_proxies(protocol: protocol.to_sym, proxy_type: proxy_type.to_sym, mode: mode.to_sym, update: true)
      end
    end
  end
end
