# frozen_string_literal: true

Memolog::Config = Struct.new(
  :debug,
  :formatter,
  :isolation_level,
  :log_size_limit,
  :middlewares,
) do
  def initialize
    self.debug = false
    self.formatter = Logger::Formatter.new
    self.isolation_level = :thread
    self.log_size_limit = 50_000
    self.middlewares = %i[rails sidekiq]
  end
end
