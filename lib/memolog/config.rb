# frozen_string_literal: true

Memolog::Config = Struct.new(:formatter, :uuid_callable, :sentry_key, :log_size_limit) do
  def initialize
    self.formatter = ::Memolog::Formatter.new
    self.uuid_callable = -> { SecureRandom.uuid }
    self.sentry_key = :memolog
    self.log_size_limit = 50_000
  end
end
