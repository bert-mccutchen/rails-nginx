require "puma"

module PumaHelpers
  PUMA_VERSION = Gem::Version.new(Puma::Const::PUMA_VERSION)

  def skip_unless_stopped_hook_supported!
    # Puma v6.5 added on_stopped.
    return if Gem::Version.new("6.5.0") <= PUMA_VERSION

    skip "Puma < 6.5 does not implement a stopped hook"
  end
end
