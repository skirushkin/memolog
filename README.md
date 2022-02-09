# Memolog

Memolog is an in-memory logger, which extend any other logger.
Designed to work with [Sentry](https://github.com/getsentry/sentry-ruby) but it's not necessary.

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
  config.formatter = ::Logger::Formatter.new
  config.middlewares = %i[rails sidekiq]
  config.log_json = false
  config.log_size_limit = 50_000
end

Memolog.init_middlewares!
```

Available options are:
- `debug` - set it to true if you need to leave Memolog.dump result outside `Memolog.run {}` block.
- `formatter` - setup your own formatter.
- `middlewares` - define here what you want to initialize in `#init_middlewares!` call.
- `log_json` - `#dump` will try to parse dump with `JSON.parse()`. Default is `false`
- `log_size_limit` - max log length in `#dump`.

If you want to apply Sentry monkey patch that call `Memolog.dump` before `Sentry.capture_exception`
and `Sentry.capture_message` you can implement it via this code:

```ruby
Sentry.prepend(Memolog::SentryExtension)
```

## Usage

Please call `Memolog.extend_logger(Rails.logger)` or any other logger you want to collect.
After that when error occured you can call `Memolog.dump` in your code and get log from
`Rails.logger` so you can collect it to another place (Sentry or etc). Also there will be unique
identifier to find logs behaviour on your server or log collection system.

Memolog has init code for Rails (Middleware) and Sidekiq (Middleware).
It implement all hacks on the `Memolog.init!` call.
Also you can add `Memolog.run {}` around logs you want to collect and release it with `Memolog.dump`
inside this block.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/skirushkin/memolog.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
