# frozen_string_literal: true

require "logger"

module Memolog
  extend self

  autoload :VERSION, "memolog/version"
  autoload :Config, "memolog/config"
  autoload :Extension, "memolog/extension"
  autoload :Formatter, "memolog/formatter"
  autoload :Middleware, "memolog/middleware"
  autoload :SentryScopeExtension, "memolog/sentry_scope_extension"
  autoload :SentrySidekiqMiddleware, "memolog/sentry_sidekiq_middleware"

  require "memolog/engine" if defined?(Rails)

  attr_accessor :debug, :logdevs

  self.debug = false
  self.logdevs = []

  def configure
    @config ||= Memolog::Config.new
    yield(@config) if block_given?
    @config
  end
  alias config configure

  def extend_logger(other_logger)
    other_logger.extend(Memolog::Extension)
    other_logger.formatter = config.formatter
  end

  def logger
    Thread.current[:memolog_logger] ||= Logger.new(nil, formatter: config.formatter)
  end

  def uuid
    Thread.current[:memolog_uuid]
  end

  def run
    Thread.current[:memolog_uuid] = Memolog.config.uuid_callable.call

    logdevs.push(StringIO.new)
    logger.instance_variable_set(:@logdev, logdevs.last)

    yield
  ensure
    logdevs.pop unless debug
  end

  def dump
    return if logdevs.empty?

    beginning = logdevs.last.string.length - config.log_size_limit
    beginning = 0 if beginning.positive?

    logdevs.last.string.slice(beginning, config.log_size_limit)
  end
end
