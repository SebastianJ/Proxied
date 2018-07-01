module Proxied
  module Jobs
    class CheckProxyJob
      include ::Sidekiq::Worker
      sidekiq_options queue: ::Proxied.configuration.job_queue

      def perform(proxy_id)
        proxy_object  =   ::Proxy.where(id: proxy_id).first

        if proxy_object
          checker     =   ::Proxied::Checker.new
          checker.check_proxy(proxy_object, update: true)
        end
      end
    end
  end
end
