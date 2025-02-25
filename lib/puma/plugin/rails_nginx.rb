# frozen_string_literal: true

require "puma/plugin"
require_relative "../../rails/nginx"

# The Puma team recommends this approach to extend the Puma DSL.
# @see https://github.com/puma/puma/discussions/3173
module Puma
  class DSL
    def rails_nginx_configs
      @rails_nginx_configs ||= {}
    end

    def rails_nginx_config(name = :primary)
      rails_nginx_configs[name] ||= {}
      yield rails_nginx_configs[name] if block_given?
      rails_nginx_configs[name]
    end
  end
end

# The Rails server command's port will override ENV['PORT'] out of the box.
# However, Rails itself does not reasign back to ENV['PORT'].
def rails_port!
  rails_port = Rails::Command::ServerCommand.new([], ARGV).options[:port]
  ENV["PORT"] = rails_port.to_s if rails_port
end

Puma::Plugin.create do
  def config(puma_config)
    rails_port!

    puma_config.clear_binds!
    puma_config.port Rails::Nginx.port

    puma_config.on_booted do
      if puma_config.rails_nginx_configs.empty?
        Rails::Nginx.start!
      else
        puma_config.rails_nginx_configs.each_value do |options|
          Rails::Nginx.start!(options)
        end
      end
    end

    puma_config.on_restart do
      if puma_config.rails_nginx_configs.empty?
        Rails::Nginx.stop!
        Rails::Nginx.start!
      else
        puma_config.rails_nginx_configs.each_value do |options|
          Rails::Nginx.stop!(options)
          Rails::Nginx.start!(options)
        end
      end
    end

    if defined?(puma_config.on_stopped)
      puma_config.on_stopped do
        if puma_config.rails_nginx_configs.empty?
          Rails::Nginx.stop!
        else
          puma_config.rails_nginx_configs.each_value do |options|
            Rails::Nginx.stop!(options)
          end
        end
      end
    end
  end
end
