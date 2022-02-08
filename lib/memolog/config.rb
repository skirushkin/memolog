# frozen_string_literal: true

Memolog::Config = Struct.new(
  :debug,
  :formatter,
  :middlewares,
  :log_json,
  :log_size_limit,
) do
  def initialize
    self.debug = false
    self.formatter = ::Logger::Formatter.new
    self.middlewares = %i[rails sidekiq]
    self.log_json = false
    self.log_size_limit = 50_000
  end
end
