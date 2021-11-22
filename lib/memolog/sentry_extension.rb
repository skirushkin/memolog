# frozen_string_literal: true

module Memolog::SentryExtension
  def self.prepended(base)
    base.singleton_class.send(:prepend, ClassMethods)
  end

  module ClassMethods
    def capture_exception(exception, **options, &block)
      add_memolog_to_current_scope!
      super
    end

    def capture_message(message, **options, &block)
      add_memolog_to_current_scope!
      super
    end

    def add_memolog_to_current_scope!
      dump = Memolog.dump
      return unless dump

      scope = get_current_scope
      scope.set_extras(Memolog.config.sentry_key => dump) if scope # rubocop:disable Style/SafeNavigation
    end
  end
end
