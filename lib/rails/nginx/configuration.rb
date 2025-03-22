# frozen_string_literal: true

module Rails
  module Nginx
    class Configuration
      def initialize(options = {})
        @options = options if rails_server?
      end

      def rails_server?
        defined?(Rails::Server)
      end

      def teardown?
        !@options[:skip_teardown]
      end

      def nginx_options
        defaults.merge(@options).except(:skip_teardown)
      end

      private

      def domain
        @options[:domain] || "#{Rails.application.class.module_parent.name.underscore.dasherize}.test"
      end

      def defaults
        {
          domain: domain,
          port: ENV["PORT"],
          root_path: Rails.public_path,
          template_path: File.expand_path("templates/nginx.conf.erb", __dir__),
          ssl: true,
          log: true,
          temp_path: Rails.root.join("tmp/nginx"),
          ssl_certificate_path: Rails.root.join("tmp/nginx/_#{domain}.pem"),
          ssl_certificate_key_path: Rails.root.join("tmp/nginx/_#{domain}-key.pem"),
          access_log_path: Rails.root.join("log/nginx/#{domain}.access.log"),
          error_log_path: Rails.root.join("log/nginx/#{domain}.error.log"),
          skip_teardown: false
        }
      end
    end
  end
end
