# frozen_string_literal: true

module Memolog::SentryScopeExtension
  def extra
    memolog_dump = Memolog.dump
    memolog_dump.present? ? super.merge!(Memolog.config.sentry_key => memolog_dump) : super
  end
end
