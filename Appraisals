# Significance: Puma < v6.5 does not have on_stopped.
appraise "puma-6-latest" do
  gem "puma", ">= 6", "< 6.5.0"
end

# Significance: Puma v6.5 added on_stopped.
appraise "puma-6.5-latest" do
  gem "puma", ">= 6.5", "< 7.0.0"
end

# Significance: Puma v7 renamed all hooks.
appraise "puma-7-latest" do
  gem "puma", ">= 7", "< 8.0.0"
end
