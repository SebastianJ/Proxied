require 'spec_helper'

RSpec.describe Proxied::Checker do
  
  %w(http socks).each do |type|
    describe "check_#{type}_proxy".to_sym, vcr: {cassette_name: "checker/#{type}"} do
      let(:checker) { Proxied::Checker.new }
      let(:proxy) { TestProxy.new(load_proxies[type].first) }
    
      it "should successfully be able to check if the #{type} proxy is working or not" do
        expect(checker.check_proxy(proxy, update: false)).to eq true
      end
    end
  end
  
end
