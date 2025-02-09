# Rails NGINX

Rails Puma plugin convenience wrapper for Ruby NGINX. Take a look at the [Ruby NGINX project documentation](https://github.com/bert-mccutchen/ruby-nginx) for more in depth details.

:heart: ERB for NGINX configuration templating.

:yellow_heart: Self-signed certificate generation via mkcert for HTTPS.

:green_heart: Tried and true NGINX for reverse proxying, and hosts mapping for DNS.

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/M4M76DVZR)

---

> [!WARNING]
>This gem is intended to be an aid to your development environment - powered by [Ruby NGINX](https://github.com/bert-mccutchen/ruby-nginx). **Don't use this gem in production.**

---

### Contents

- [Installation](#installation)
- [Usage](#usage)
  - [Basic Usage](#basic-usage)
  - [Default Configuration](#default-configuration)
  - [Advanced Usage](#advanced-usage)
    - [Multiple Configurations](#multiple-configurations)
    - [Inheriting Configurations](#inheriting-configurations)
- [Development](#development)
  - [Setup](#setup)
  - [Lint / Test](#lint--test)
  - [Debug Console](#debug-console)
  - [Release](#release)
- [Contributing](#contributing)
- [License](#license)

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

### Basic Usage

Add the Puma plugin to your configuration, and limit it to your development environment.

**config/puma.rb**
```ruby
plugin :rails_nginx if Rails.env.development?
```

> [!IMPORTANT]
> **If you skip this, NGINX reverse proxy will have a randomized port while Puma will not. The reverse proxy will not work.**
>
> Puma's `port` configuration option makes it impossible for Rails NGINX to assign a random open port back to Puma.
>
> To fix this issue, simply remove it from our Puma configuration.
>
> **config/puma.rb**
> ```ruby
> port ENV.fetch("PORT") { 3000 }
> ```
>
> OR simply disable it in your development environment:
> ```ruby
> port ENV.fetch("PORT") { 3000 } unless Rails.env.development?
> ```
>
> OR always manually provide an open port when starting Rails:
> ```
> ./bin/rails server -p 3001
> ```

### Default Configuration
By default, Rails NGINX will configure [Ruby NGINX](https://github.com/bert-mccutchen/ruby-nginx) with the following options. For the examples, pretend I have an application called "HelloWorld".

| Option | Default | Example |
|---|---|---|
| `domain` | Your rails app name as dashes, with the test TLD. | `hello-world.test` |
| `host` | `127.0.0.1` | |
| `root_path` | `Rails.public_path` | `/home/bert/hello_world/public` |
| `ssl` | `true` | |
| `log` | `true` | |
| `ssl_certificate_path` | `Rails.root` + `tmp/nginx/_[DOMAIN].pem` | `/home/bert/hello_world/tmp/nginx/_hello-world.test.pem` |
| `ssl_certificate_key_path` | `Rails.root` + `tmp/nginx/_[DOMAIN]-key.pem` | `/home/bert/hello_world/tmp/nginx/_hello-world.test-key.pem` |
| `access_log_path` | `Rails.root` + `log/nginx/[DOMAIN].access.log` | `/home/bert/hello_world/log/hello-world.test.access.log` |
| `error_log_path` | `Rails.root` + `log/nginx/[DOMAIN].error.log` | `/home/bert/hello_world/log/hello-world.test.error.log` |

### Advanced Usage

You can override all the default values and provide your own configuration. Rails NGINX will use your configuration automatically if one is present. Default values are retained if not overridden.

**config/puma.rb**
```ruby
rails_nginx_config do |config|
  config[:domain] = "example.test"
  config[:host] = "localhost"
  # etc.
end
```

#### Multiple Configurations

Let's say you have a multi-tenant Rails application, and you want to simulate the application running behind two separate domains in your development environment. No problem, Rails NGINX can support multiple configurations, no matter how wildly different they may be.

**config/puma.rb**
```ruby
rails_nginx_config(:work) do |config|
  config[:domain] = "work.todo-list.test"
  config[:ssl] = true
  config[:log] = true

  config[:ssl_certificate_path] = "~/work/my-cert.pem"
  config[:ssl_certificate_key_path] = "~/work/my-cert-key.pem"

  # default location Rails.root + log/nginx/
  config[:access_log_path] = "~/work/logs/todo-list.access.log"
  config[:error_log_path] = "~/work/logs/todo-list.error.log"
end

rails_nginx_config(:home) do |config|
  config[:domain] = "home.todo-list.test"
  config[:ssl] = false
  config[:log] = false
end
```

#### Inheriting Configurations

Since Rails NGINX configurations are a simple Ruby Hash, you can merge configurations to prevent needless duplication. This is possible because Rails NGINX allows you to read back previously defined configurations.

**config/puma.rb**
```ruby
rails_nginx_config(:kids) do |config|
  config.merge!(rails_nginx_config(:home))

  config[:domain] = "kids.todo-list.test"
  config[:log] = true
end
```

## Development

### Setup

Install development dependencies.
```
./bin/setup
```

### Lint / Test

Run the Standard Ruby linter, and RSpec test suite.
```
bundle exec rake
```

#### Generating a new Dummy server

There's a built-in executable if you'd like to generate a new Dummy server to upgrade the regression tests to work with the latest version of Rails.

This executable will delete the current `spec/dummy` directory, update the `rails` gem to the latest version, and generate a new `spec/dummy` application using the options defined in the `.dummy.railsrc` file.
```
./bin/dummy
```

### Debug Console

Start an interactive Ruby console (IRB).
```
./bin/console
```

### Release

A new release will automatically be built and uploaded to RubyGems by a [GitHub Actions workflow](./.github/workflows/gem-push.yml) upon the push of a new Git tag.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bert-mccutchen/rails-nginx.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
