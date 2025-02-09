# frozen_string_literal: true

RSpec.describe Rails::Nginx do
  it "adds the hosts mapping" do
    RetryExpectation.new(limit: 30, delay: 1).attempt do
      hosts = File.read("/etc/hosts")
      expect(hosts).to include("dummy.test")
    end
  end

  it "creates the NGINX configuration" do
    RetryExpectation.new(limit: 30, delay: 1).attempt do
      path = File.expand_path("~/.ruby-nginx/servers/ruby_nginx_dummy_test.conf")
      expect(File.exist?(path)).to be_truthy
    end
  end

  it "creates the SSL certificate" do
    RetryExpectation.new(limit: 30, delay: 1).attempt do
      path = "#{RSpec.configuration.dummy_path}/tmp/nginx/_dummy.test.pem"
      expect(File.exist?(path)).to be_truthy

      path = "#{RSpec.configuration.dummy_path}/tmp/nginx/_dummy.test-key.pem"
      expect(File.exist?(path)).to be_truthy
    end
  end

  it "creates the log files" do
    RetryExpectation.new(limit: 30, delay: 1).attempt do
      path = "#{RSpec.configuration.dummy_path}/log/nginx/dummy.test.access.log"
      expect(File.exist?(path)).to be_truthy

      path = "#{RSpec.configuration.dummy_path}/log/nginx/dummy.test.error.log"
      expect(File.exist?(path)).to be_truthy
    end
  end

  it "successfully builds up a NGINX site" do
    RetryExpectation.new(limit: 30, delay: 1).attempt do
      html = `curl -s http://dummy.test`
      expect(html).to include("Rails version")

      html = `curl -s https://dummy.test`
      expect(html).to include("Rails version")
    end
  end
end
