# frozen_string_literal: true

require "socket"
require "ruby/nginx"

module Rails
  module Nginx
    class Error < StandardError; end

    def self.port
      ENV["PORT"] ||= Addrinfo.tcp("127.0.0.1", 0).bind { |s| s.local_address.ip_port }.to_s
    end

    def self.start!(options = {}, &block)
      return unless rails_server?

      config = Ruby::Nginx.add!(options.reverse_merge(defaults(options)), &block)

      puts start_message(config.options) # rubocop:disable Rails/Output
    end

    def self.stop!(options = {}, &block)
      return unless rails_server?

      Ruby::Nginx.remove!(options.reverse_merge(defaults(options)), &block)
    end

    private

    def self.rails_server?
      defined?(Rails::Server)
    end
    private_class_method :rails_server?

    def self.defaults(options)
      domain = options[:domain] || "#{Rails.application.class.module_parent.name.underscore.dasherize}.test"

      {
        domain: domain,
        port: port,
        root_path: Rails.public_path,
        ssl: true,
        log: true,
        ssl_certificate_path: Rails.root.join("tmp/nginx/_#{domain}.pem"),
        ssl_certificate_key_path: Rails.root.join("tmp/nginx/_#{domain}-key.pem"),
        access_log_path: Rails.root.join("log/nginx/#{domain}.access.log"),
        error_log_path: Rails.root.join("log/nginx/#{domain}.error.log")
      }
    end
    private_class_method :defaults

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
  end
end
