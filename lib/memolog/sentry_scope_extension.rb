# frozen_string_literal: true

module Memolog::SentryScopeExtension
  def apply_to_event(scope, hint = nil)
    memolog_dump = Memolog.dump
    set_extras(Memolog.config.sentry_key => memolog_dump) if memolog_dump

    super
  end
end
