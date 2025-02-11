# frozen_string_literal: true

RSpec.describe Rails::Nginx do
  before(:all) do
    puts "Starting Dummy Server"
    DummyServer.instance.start
  rescue
    DummyServer.instance.stop
  end

  after(:all) do
    puts "Stopping Dummy Server"
    DummyServer.instance.stop
  end

  it "adds the default hosts mapping" do
    retry_expectation(limit: 30, delay: 1) do
      hosts = File.read("/etc/hosts")
      expect(hosts).to include("127.0.0.1 dummy.test")
    end
  end

  it "adds the custom hosts mapping" do
    retry_expectation(limit: 30, delay: 1) do
      hosts = File.read("/etc/hosts")
      expect(hosts).to include("127.0.0.1 custom.dummy.test")
    end
  end

  it "creates the default NGINX configuration" do
    retry_expectation(limit: 30, delay: 1) do
      path = File.expand_path("~/.ruby-nginx/servers/ruby_nginx_dummy_test.conf")
      expect(File.exist?(path)).to be_truthy
    end
  end

  it "creates the custom NGINX configuration" do
    retry_expectation(limit: 30, delay: 1) do
      path = File.expand_path("~/.ruby-nginx/servers/ruby_nginx_custom_dummy_test.conf")
      expect(File.exist?(path)).to be_truthy
    end
  end

  it "creates the default SSL certificate" do
    retry_expectation(limit: 30, delay: 1) do
      path = "#{RSpec.configuration.dummy_path}/tmp/nginx/_dummy.test.pem"
      expect(File.exist?(path)).to be_truthy

      path = "#{RSpec.configuration.dummy_path}/tmp/nginx/_dummy.test-key.pem"
      expect(File.exist?(path)).to be_truthy
    end
  end

  it "does not create the custom SSL certificate" do
    retry_expectation(limit: 30, delay: 1) do
      path = "#{RSpec.configuration.dummy_path}/tmp/nginx/_custom.dummy.test.pem"
      expect(File.exist?(path)).to be_falsey

      path = "#{RSpec.configuration.dummy_path}/tmp/nginx/_custom.dummy.test-key.pem"
      expect(File.exist?(path)).to be_falsey
    end
  end

  it "creates the default log files" do
    retry_expectation(limit: 30, delay: 1) do
      path = "#{RSpec.configuration.dummy_path}/log/nginx/dummy.test.access.log"
      expect(File.exist?(path)).to be_truthy

      path = "#{RSpec.configuration.dummy_path}/log/nginx/dummy.test.error.log"
      expect(File.exist?(path)).to be_truthy
    end
  end

  it "does not create the custom log files" do
    retry_expectation(limit: 30, delay: 1) do
      path = "#{RSpec.configuration.dummy_path}/log/nginx/custom.dummy.test.access.log"
      expect(File.exist?(path)).to be_falsey

      path = "#{RSpec.configuration.dummy_path}/log/nginx/custom.dummy.test.error.log"
      expect(File.exist?(path)).to be_falsey
    end
  end

  it "successfully builds up the default NGINX site with SSL" do
    retry_expectation(limit: 30, delay: 1) do
      html = `curl -s http://dummy.test`
      expect(html).to include("Rails version")

      html = `curl -s https://dummy.test`
      expect(html).to include("Rails version")
    end
  end

  it "successfully builds up the custom NGINX site without SSL" do
    retry_expectation(limit: 30, delay: 1) do
      html = `curl -s http://custom.dummy.test`
      expect(html).to include("Rails version")

      html = `curl -s https://custom.dummy.test`
      expect(html).to eq("")
    end
  end
end
