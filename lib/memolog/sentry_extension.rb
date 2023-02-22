# frozen_string_literal: true

module Memolog::SentryExtension
  def self.prepended(base)
    base.singleton_class.send(:prepend, ClassMethods)
  end

  module ClassMethods
    def capture_exception(exception, **options, &block)
      set_extras_memolog!
      super
    end

    def capture_message(message, **options, &block)
      set_extras_memolog!
      super
    end

    def set_extras_memolog!
      return unless get_current_scope
      set_extras(memolog: Memolog.dump(parse_json: true))
    end
  end
end
