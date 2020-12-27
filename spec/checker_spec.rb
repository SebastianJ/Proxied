require 'spec_helper'

RSpec.describe Proxied::Checker do
  
  %w(http socks).each do |protocol|
    describe "check_#{protocol}_proxies".to_sym, vcr: {cassette_name: "checker/#{protocol}_proxies"} do
      let(:checker) { Proxied::Checker.new }
      let(:proxies) { load_proxies[protocol] }
    
      it "should successfully be able to check if the #{protocol} proxies are working or not" do
        proxies.each do |proxy|
          proxy   =   TestProxy.new(proxy)
          expect(checker.check_proxy(proxy, protocol: protocol, update: false)).to eq true
        end
      end
    end
  end
  
end
