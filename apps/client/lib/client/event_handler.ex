defmodule Client.EventHandler do
  alias Client.{MessageLogger, Tipper}

  def handle(_conn, _me, :privmsg, message) do
    MessageLogger.log(:privmsg, message)
    Tipper.check(message)
  end

  def handle(_conn, :join, %{nick: nick}, channel) do
    MessageLogger.log(:join, nick, channel)
  end

  def handle(_conn, :part, %{nick: nick}, channel, _message) do
    MessageLogger.log(:part, nick, channel)
  end
end
