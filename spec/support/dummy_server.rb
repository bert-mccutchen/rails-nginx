require "singleton"

ENV["SKIP_PROMPT"] = "true"
APP_PATH = File.expand_path("../dummy/config/application", __dir__)
ARGV = ["server", "-p", "3001"]

class DummyServer
  include Singleton

  def initialize
    @semaphore = Mutex.new
    @server = nil
  end

  def start
    @semaphore.synchronize do
      @server = Thread.new do
        require "rails/commands"
        require "rails/commands/server/server_command"

        Rails::Command::ServerCommand.new([], []).perform
      end
    end
  end

  def stop
    @semaphore.synchronize do
      @server.exit if @server.alive?
    end
  end
end
