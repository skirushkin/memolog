# frozen_string_literal: true

module Memolog::LoggerExtension
  def add(*args, &block)
    Memolog.add(*args, &block)
    super
  end
end
