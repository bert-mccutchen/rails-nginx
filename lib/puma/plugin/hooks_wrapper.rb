module HooksWrapper
  def booted(config, &)
    if new_hooks?
      config.after_booted(&)
    else
      config.on_booted(&)
    end
  end

  def restarted(config, &)
    if new_hooks?
      config.before_restart(&)
    else
      config.on_restart(&)
    end
  end

  def stopped(config, &)
    return unless stopped_hook?

    if new_hooks?
      config.after_stopped(&)
    else
      config.on_stopped(&)
    end
  end

  private

  PUMA_VERSION = Gem::Version.new(Puma::Const::PUMA_VERSION)

  def new_hooks?
    # Puma renamed their hooks in v7.
    Gem::Version.new("7.0.0") <= PUMA_VERSION
  end

  def stopped_hook?
    # Puma v6.5 added on_stopped.
    Gem::Version.new("6.5.0") <= PUMA_VERSION
  end
end
