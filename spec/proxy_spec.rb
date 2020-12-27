require 'spec_helper'

RSpec.describe TestProxy do
  let(:proxy) { 
    TestProxy.new(host: "127.0.0.1", port: 8888, protocol: 'http', username: "pr0xyUsr", password: "12345", country: "uk") 
  }
  
  it "should generate the correct proxy address with http:// as a prefix" do
    expect(proxy.proxy_address(include_protocol: true)).to eq "http://127.0.0.1:8888"
  end

  it "should generate the correct proxy address with https:// as a prefix" do
    proxy.protocol = 'https'
    expect(proxy.proxy_address(include_protocol: true)).to eq "https://127.0.0.1:8888"
  end

  it "should generate the correct proxy address with socks:// as a prefix" do
    proxy.protocol = 'socks'
    expect(proxy.proxy_address(include_protocol: true)).to eq "socks://127.0.0.1:8888"
  end
  
  it "should generate the correct proxy address without http:// as a prefix" do
    expect(proxy.proxy_address(include_protocol: false)).to eq "127.0.0.1:8888"
  end
  
  it "should generate a formatted username:password combination" do
    expect(proxy.proxy_credentials).to eq "pr0xyUsr:12345"
  end
  
  it "should generate a correct credentials hash to be used with socks" do
    expect(proxy.socks_proxy_credentials).to eq({user: "pr0xyUsr", password: "12345"})
  end
  
  it "should generate a correct options hash to be used with Faraday" do
    expect(proxy.proxy_options_for_faraday).to eq({uri: "http://127.0.0.1:8888", user: "pr0xyUsr", password: "12345"})
  end
end
