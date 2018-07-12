require 'vcr'
require 'webmock/rspec'
require_relative 'proxies'

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = false
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
  c.configure_rspec_metadata!
  
  load_proxies.each do |type, proxies|
    proxies.each do |proxy|
      c.filter_sensitive_data("PROXY_IP") do |interaction|
        proxy["host"]
      end
    end
  end
  
end
