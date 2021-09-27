# frozen_string_literal: true

module Memolog::Extension
  def add(*args, &block)
    Memolog.logger.log(*args, &block)
    super
  end

  def log(*args, &block)
    Memolog.logger.log(*args, &block)
    super
  end
end
