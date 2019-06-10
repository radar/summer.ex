defmodule Summer.Conn do
  alias Summer.{Conn, Message, Writer}

  defstruct [:me, :writer, :channels, :command_handler, :event_handler]

  def register(%Conn{me: me} = conn) do
    conn |> reply("USER #{me} #{me} #{me} #{me}")
    conn |> reply("NICK #{me}")
  end

  def join(%Conn{} = conn, channel) do
    conn |> reply("JOIN #{channel}")
  end

  def reply(%Conn{writer: writer}, message) do
    Writer.write(writer, message)
  end

  def privmsg_reply(%Conn{me: me} = conn, %Message{channel: channel, sender: %{nick: nick}}, text) do
    reply_to = if channel == me, do: nick, else: channel
    reply(conn, :privmsg, reply_to, text)
  end

  def reply(%Conn{writer: writer}, type, dest, message) do
    Writer.write(writer, type, dest, message)
  end

  def handle_event(%Conn{event_handler: event_handler, me: me} = conn, type, message) do
    event_handler.handle(conn, me, type, message)
  end

  def handle_event(%Conn{event_handler: event_handler, me: me} = conn, type, sender, channel) do
    event_handler.handle(conn, type, sender, channel)
  end

  def handle_command(%Conn{command_handler: command_handler} = conn, command) do
    command_handler.handle(conn, command)
  end
end
