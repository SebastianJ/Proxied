module Proxied
  module Jobs
    class CheckProxyJob
      include ::Sidekiq::Worker
      sidekiq_options queue: :proxies

      def perform(proxy_id)
        proxy_object  =   ::Proxy.where(id: proxy_id).first

        if proxy_object
          checker     =   ::Proxied::Checker.new
          checker.check_proxy(proxy_object)
          checker.update_proxies
        end
      end
    end
  end
end
