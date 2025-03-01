require "singleton"

ENV["SKIP_PROMPT"] = "true"
APP_PATH = File.expand_path("../dummy/config/application", __dir__)
ARGV = ["server", "-p", "3001"]

class DummyServer
  include Singleton

  def initialize
    @semaphore = Mutex.new
    @pid = nil
  end

  def start
    @semaphore.synchronize do
      @pid = Process.fork do
        require "rails/commands"
        require "rails/commands/server/server_command"

        Rails::Command::ServerCommand.new([], []).perform
      end
    end
  end

  def stop
    @semaphore.synchronize do
      Process.kill(:TERM, @pid)
      Process.wait
    end
  end
end
