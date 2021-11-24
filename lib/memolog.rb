# frozen_string_literal: true

require "logger"
require "securerandom"
require "stringio"

require "memolog/version"
require "memolog/config"
require "memolog/extension"
require "memolog/formatter"
require "memolog/init"
require "memolog/rails_middleware"
require "memolog/sentry_extension"
require "memolog/sidekiq_middleware"

module Memolog
  extend self

  attr_accessor :config

  @config = Memolog::Config.new

  def configure
    yield(config) if block_given?
  end

  def init_middlewares!
    Memolog::Init.init_middlewares!
  end

  def extend_logger(other_logger)
    other_logger.extend(Memolog::Extension)
    other_logger.formatter = config.formatter
  end

  def uuid
    Thread.current[:memolog_uuid]
  end

  def logger
    Thread.current[:memolog_logger] ||= Logger.new(nil, formatter: config.formatter)
  end

  def logdevs
    Thread.current[:memolog_logdevs] ||= []
  end

  def run
    Thread.current[:memolog_uuid] = config.uuid_callable.call

    logdevs.push(StringIO.new)
    logger.instance_variable_set(:@logdev, logdevs.last)

    yield
  ensure
    logdevs.pop unless config.debug
  end

  def dump
    return if logdevs.empty?

    beginning = logdevs.last.string.length - config.log_size_limit
    beginning = 0 if beginning.negative?

    logdevs.last.string.slice(beginning, config.log_size_limit).presence
  end
end
