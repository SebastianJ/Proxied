module Proxied
  class Checker
    attr_accessor :mode
    attr_accessor :minimum_successful_attempts, :maximum_failed_attempts
    attr_accessor :limit

    def initialize(mode: :synchronous, minimum_successful_attempts: ::Proxied.configuration.minimum_successful_attempts, maximum_failed_attempts: ::Proxied.configuration.maximum_failed_attempts, limit: nil)
      self.mode                         =   mode
      self.minimum_successful_attempts  =   minimum_successful_attempts
      self.maximum_failed_attempts      =   maximum_failed_attempts
      self.limit                        =   limit
    end

    def check_proxies(protocol: :all, proxy_type: :all, category: nil, update: true)
      proxies                           =   ::Proxied.configuration.proxy_class.constantize.should_be_checked(
        mode:                    self.mode.to_sym,
        protocol:                protocol,
        proxy_type:              proxy_type,
        category:                category,
        date:                    Time.now,
        limit:                   self.limit,
        maximum_failed_attempts: self.maximum_failed_attempts
      )

      if proxies&.any?
        ::Proxied::Logger.log "Found #{proxies.size} #{proxy_type} proxies to check."

        proxies.each do |proxy|
          case self.mode.to_sym
            when :synchronous
              check_proxy(proxy, update: update)
            when :asynchronous
              ::Proxied::Jobs::CheckProxyJob.perform_async(proxy.id.to_s)
          end
        end
      else
        ::Proxied::Logger.log "Couldn't find any proxies to check!"
      end
    end

    def check_proxy(proxy, protocol: nil, update: true)
      ::Proxied::Logger.log "#{Time.now}: Will check if proxy #{proxy.proxy_address} is working."
      protocol ||= proxy.protocol
      
      self.send("check_#{protocol}_proxy", proxy, update: update)
    end

    def check_socks_proxy(
      proxy, 
      test_host:  ::Proxied.configuration.socks_test[:hostname], 
      test_port:  ::Proxied.configuration.socks_test[:port], 
      test_query: ::Proxied.configuration.socks_test[:query], 
      timeout:    ::Proxied.configuration.socks_test[:timeout], 
      update:     true
    )
      valid_proxy     =   false

      begin
        socks_proxy   =   ::Net::SSH::Proxy::SOCKS5.new(proxy.host, proxy.port, proxy.socks_proxy_credentials)
        socket        =   socks_proxy.open(test_host, test_port, {timeout: timeout})

        socket.write("#{test_query}\r\n")
        response      =   socket.read
        valid_proxy   =   !response.to_s.empty? && response.downcase.include?(test_query.gsub(/^=/, '').downcase)

        socket.close

      rescue StandardError => e
        ::Proxied::Logger.log "Exception occured while trying to check proxy #{proxy.proxy_address}. Error Class: #{e.class}. Error Message: #{e.message}"
        valid_proxy   =   false
      end

      update_proxy(proxy, valid_proxy) if update

      return valid_proxy
    end

    def check_https_proxy(
      proxy,
      test_url: ::Proxied.configuration.http_test[:url],
      evaluate: ::Proxied.configuration.http_test[:evaluate],
      timeout:  ::Proxied.configuration.http_test[:timeout],
      update:   true)
      
      return check_http_proxy(proxy, test_url: test_url, evaluate: evaluate, timeout: timeout, update: update)
    end

    def check_http_proxy(
      proxy,
      test_url: ::Proxied.configuration.http_test[:url],
      evaluate: ::Proxied.configuration.http_test[:evaluate],
      timeout:  ::Proxied.configuration.http_test[:timeout],
      update:   true)

      ::Proxied::Logger.log "#{Time.now}: Fetching #{::Proxied.configuration.http_test[:url]} with proxy #{proxy.proxy_address} (#{proxy.ip_address})."

      response                    =   request(test_url, proxy, options: {timeout: timeout})
      valid_proxy                 =   evaluate.call(proxy, response)

      update_proxy(proxy, valid_proxy, response) if update

      return valid_proxy
    end

    def update_proxy(proxy, valid, response = nil)      
      ::Proxied::Logger.info "#{Time.now}: Proxy #{proxy.proxy_address} (#{proxy.ip_address}) is #{valid ? "working" : "not working"}!"
      ::Proxied::Logger.debug "Response: #{response}" if !valid && response

      successful_attempts         =   proxy.successful_attempts || 0
      failed_attempts             =   proxy.failed_attempts || 0

      if valid
        successful_attempts      +=  1
      else
        failed_attempts          +=  1
      end

      is_valid                    =   (successful_attempts >= self.minimum_successful_attempts && failed_attempts < self.maximum_failed_attempts)

      proxy.valid_proxy           =   is_valid
      proxy.successful_attempts   =   successful_attempts
      proxy.failed_attempts       =   failed_attempts
      proxy.last_checked_at       =   Time.now
      proxy.save
    end

    private
      def request(url, proxy, options: {})
        response                  =   nil
        
        user_agent                =   options.fetch(:user_agent, ::Proxied.configuration.faraday.fetch(:user_agent, nil)&.call)
        timeout                   =   options.fetch(:timeout, ::Proxied.configuration.http_test[:timeout])
        auth_mode                 =   proxy.respond_to?(:auth_mode) ? proxy.auth_mode : 'credentials'

        begin
          connection              =   ::Faraday.new(url: url) do |builder|
            builder.headers["User-Agent"]   =   user_agent if !user_agent.to_s.empty?
            builder.options[:timeout]       =   timeout if timeout
            builder.proxy                   =   proxy.proxy_options_for_faraday
            #builder.basic_auth(proxy.username, proxy.password) if using_basic_auth?(auth_mode)
            builder.response :logger if ::Proxied.configuration.verbose_faraday?
            builder.adapter ::Proxied.configuration.faraday.fetch(:adapter, :net_http)
          end

          response                =   connection.get&.body
          
        rescue Faraday::TimeoutError, Faraday::Error => e
          ::Proxied::Logger.log "Exception occured while trying to check proxy #{proxy.proxy_address}. Error Class: #{e.class}. Error Message: #{e.message}"
        end
        
        return response
      end

      def using_credentials?(mode)
        mode.to_s.eql?('credentials')
      end

      def using_basic_auth?(mode)
        mode.to_s.eql?('basic') || mode.to_s.eql?('basic_auth')
      end

  end
end
