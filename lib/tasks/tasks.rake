namespace :proxied do
  task :check_proxies, [:protocol, :proxy_type, :mode, :maximum_failed_attempts] => :environment do |task, args|
    args.with_defaults(protocol: :http, proxy_type: :public, mode: :synchronous, maximum_failed_attempts: 10)
    
    checker = ::Proxied::Checker.new(maximum_failed_attempts: args.maximum_failed_attempts.to_i)
    checker.check_proxies(
      protocol:     args.protocol.to_sym, 
      proxy_type:   args.proxy_type.to_sym, 
      mode:         args.mode.to_sym
    )
  end
end
