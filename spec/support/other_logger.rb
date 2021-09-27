# frozen_string_literal: true

shared_context "with other logger", :with_other_logger do
  let(:other_logger_buffer) { StringIO.new }
  let(:other_logger) { Logger.new(other_logger_buffer) }

  before("extend other_logger") { Memolog.extend_logger(other_logger) }
end
