# frozen_string_literal: true

module Memolog::SentrySidekiqMiddlewareExtension
  def call(worker, job, queue)
    Memolog.run { super }
  end
end
