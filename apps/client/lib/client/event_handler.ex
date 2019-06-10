defmodule Client.EventHandler do
  alias Client.{MessageLogger, Tipper}

  def handle(
    _conn,
    _me,
    :privmsg,
    message
  ) do
    MessageLogger.log(message)
    Tipper.check(message)
  end

  def handle(
    _conn,
    :join,
    joiner,
    channel
  ) do
    IO.puts "JOINED! #{joiner} joined #{channel}"
  end
end
