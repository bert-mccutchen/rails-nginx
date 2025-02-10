# frozen_string_literal: true

RSpec.describe Ruby::Nginx do
  it "removes the default hosts mapping" do
    RetryExpectation.new(limit: 3, delay: 1).attempt do
      hosts = File.read("/etc/hosts")
      expect(hosts).not_to include("dummy.test")
    end
  end

  it "removes the custom hosts mapping" do
    RetryExpectation.new(limit: 3, delay: 1).attempt do
      hosts = File.read("/etc/hosts")
      expect(hosts).not_to include("custom.dummy.test")
    end
  end

  it "deletes the default NGINX configuration" do
    RetryExpectation.new(limit: 3, delay: 1).attempt do
      path = File.expand_path("~/.ruby-nginx/servers/ruby_nginx_dummy_test.conf")
      expect(File.exist?(path)).to be_falsey
    end
  end

  it "deletes the custom NGINX configuration" do
    RetryExpectation.new(limit: 3, delay: 1).attempt do
      path = File.expand_path("~/.ruby-nginx/servers/ruby_nginx_custom_dummy_test.conf")
      expect(File.exist?(path)).to be_falsey
    end
  end

  it "successfully tears down the default NGINX site" do
    RetryExpectation.new(limit: 3, delay: 1).attempt do
      html = `curl -s http://dummy.test`
      expect(html).to eq("")

      html = `curl -s https://dummy.test`
      expect(html).to eq("")
    end
  end

  it "successfully tears down the custom NGINX site" do
    RetryExpectation.new(limit: 3, delay: 1).attempt do
      html = `curl -s http://custom.dummy.test`
      expect(html).to eq("")

      html = `curl -s https://custom.dummy.test`
      expect(html).to eq("")
    end
  end
end
