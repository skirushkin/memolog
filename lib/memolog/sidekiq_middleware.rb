# frozen_string_literal: true

class Memolog::SidekiqMiddleware
  def call(*)
    Memolog.run { yield } # rubocop:disable Style/ExplicitBlockArgument
  end
end
