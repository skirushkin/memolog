# frozen_string_literal: true

Memolog::Config = Struct.new(
  :debug,
  :formatter,
  :middlewares,
  :log_size_limit,
) do
  def initialize
    self.debug = false
    self.formatter = Logger::Formatter.new
    self.middlewares = %i[rails sidekiq]
    self.log_size_limit = 50_000
  end
end
