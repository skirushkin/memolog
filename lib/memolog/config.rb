# frozen_string_literal: true

Memolog::Config = Struct.new(
  :debug,
  :formatter,
  :middlewares,
  :log_size_limit,
  :uuid_callable,
) do
  def initialize
    self.debug = false
    self.formatter = ::Memolog::Formatter.new
    self.middlewares = %i[rails sidekiq]
    self.log_size_limit = 50_000
    self.uuid_callable = -> { SecureRandom.uuid }
  end
end
