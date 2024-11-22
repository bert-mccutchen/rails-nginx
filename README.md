# Rails NGINX

Automatically configure NGINX with SSL upon boot for Rails applications.

1. ERB for NGINX configuration templating.
2. Mkcert for SSL certificate generation.
3. Tried and true NGINX for reverse proxying.

This gem is intended to be an aid to your development environment. **Don't use this in production.**

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/M4M76DVZR)

## Installation

Install via Bundler:
```bash
bundle add rails-nginx
```

Or install it manually:
```bash
gem install rails-nginx
```

## Usage

### config/puma.rb
```ruby
port ENV.fetch('PORT') { 3000 } unless Rails.env.development?

plugin :rails_nginx if Rails.env.development?

# All configuration is entirely optional, the following blocks are not required.
rails_nginx_config(:primary) do |config|
  config[:domain] = 'route1.spline-reticulator.test' # default eg. rails-app-name.test
  config[:host] = '0.0.0.0' # default '127.0.0.1'
  config[:root_path] = './public' # default `Rails.public_path`
  config[:ssl] = false # default true
  config[:log] = false # default true

  # default location Rails.root + tmp/nginx/
  config[:ssl_certificate_path] = './tmp/certs/_spline-reticulator.test.pem'
  config[:ssl_certificate_key_path] = './tmp/certs/_spline-reticulator-key.test.pem'

  # default location Rails.root + log/nginx/
  config[:access_log_path] = './log/route1.nginx.access.log'
  config[:error_log_path] = './log/route1.nginx.error.log'
end

# You can define multiple configurations and all will be created on puma boot.
rails_nginx_config(:secondary) do |config|
  config.merge!(rails_nginx_config(:primary))

  config[:domain] = 'route2.spline-reticulator.test'
  config[:access_log_path] = './log/route2.nginx.access.log'
  config[:error_log_path] = './log/route2.nginx.error.log'
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bert-mccutchen/rails-nginx.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
