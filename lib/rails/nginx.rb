# frozen_string_literal: true

require "socket"
require "ruby/nginx"
require_relative "nginx/configuration"
require_relative "nginx/version"

module Rails
  module Nginx
    class Error < StandardError; end

    def self.port
      ENV["PORT"] ||= Addrinfo.tcp("127.0.0.1", 0).bind { |s| s.local_address.ip_port }.to_s
    end

    def self.start!(options = {}, &block)
      rails_config = Configuration.new(options)
      return unless rails_config.rails_server?

      config = Ruby::Nginx.add!(rails_config.nginx_options, &block)

      puts start_message(config.options)
    rescue Ruby::Nginx::Error => e
      abort "[Ruby::Nginx] #{e.message}"
    end

    def self.stop!(options = {}, &block)
      rails_config = Configuration.new(options)
      return unless rails_config.rails_server? && rails_config.teardown?

      puts stop_message(rails_config.nginx_options)
      Ruby::Nginx.remove!(rails_config.nginx_options, &block)
    rescue Ruby::Nginx::Error => e
      abort "[Ruby::Nginx] #{e.message}"
    end

    private

    def self.start_message(config)
      message = ["* Rails NGINX version: #{Rails::Nginx::VERSION}"]
      message << "*       HTTP Endpoint: http://#{config[:domain]}"
      message << "*      HTTPS Endpoint: https://#{config[:domain]}" if config[:ssl]
      message << "*          Access Log: #{config[:access_log_path]}" if config[:log]
      message << "*           Error Log: #{config[:error_log_path]}" if config[:log]
      message << "* Upstreaming to http://#{config[:host]}:#{config[:port]}"
      message.join("\n")
    end
    private_class_method :start_message

    def self.stop_message(config)
      "- Tearing down Rails NGINX config: #{config[:domain]}"
    end
    private_class_method :stop_message
  end
end
