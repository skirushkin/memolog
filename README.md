# Memolog

Memolog is an in-memory logger, which extend any other logger.
Designed to work with [Sentry](https://github.com/getsentry/sentry-ruby).
It add `memolog` extra section to Sentry errors.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "memolog"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install memolog

## Usage

Memolog has init code for Rails (Middleware), Sentry (Extension) and Sidekiq (Middleware).
It implement all hacks on the load process.
Also you can add `Memolog.run {}` around logs you want to collect and release it with `Memolog.dump`
inside this block.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/skirushkin/memolog.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
