# frozen_string_literal: true

module Memolog::LoggerExtension
  def add(*args, &block)
    Memolog.log(*args, &block)
    super
  end

  def log(*args, &block)
    Memolog.log(*args, &block)
    super
  end
end
