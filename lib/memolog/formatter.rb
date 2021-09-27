# frozen_string_literal: true

class Memolog::Formatter < Logger::Formatter
  def call(severity, time, _progname, msg)
    format(
      Format,
      severity[0..0],
      format_datetime(time),
      $PID,
      severity,
      Memolog.uuid,
      msg2str(msg),
    )
  end
end
