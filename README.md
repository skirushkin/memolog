# Memolog

Memolog is an in-memory logger, which extend any other logger.
Designed to work with [Sentry](https://github.com/getsentry/sentry-ruby).
It adds `memolog` extra section to Sentry errors.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "memolog"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install memolog

## Configuration

Use this example during application initialization process (this example implement default values):

```ruby
Memolog.configure do |config|
  config.debug = false
  config.formatter = ::Memolog::Formatter.new
  config.initializers = %i[rails sentry sidekiq]
  config.log_size_limit = 50_000
  config.sentry_key = :memolog
  config.uuid_callable = -> { SecureRandom.uuid }
end

Memolog.init!
```

Available options are:
- `debug` - set it to true if you need to leave Memolog.dump result outside `Memolog.run {}` block.
- `formatter` - setup your own formatter.
- `initializers` - define here what you want to initialize in `#init!` call.
- `log_size_limit` - max log length in Sentry event.
- `sentry_key` - key name in Sentry extra object.
- `uuid_callable` - Memolog add unique value to logs, here you can redefine uuid generation.

## Usage

Please call `Memolog.extend_logger(Rails.logger)` or any other logger you want to collect.
After that when error occured you can check your Sentry report and see `memolog` section with all
logs collected before error. Also there will be unique identifier to find logs behaviour on your
server or log collection system.

Memolog has init code for Rails (Middleware), Sentry (Extension) and Sidekiq (Middleware).
It implement all hacks on the `Memolog.init!` call.
Also you can add `Memolog.run {}` around logs you want to collect and release it with `Memolog.dump`
inside this block.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/skirushkin/memolog.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
