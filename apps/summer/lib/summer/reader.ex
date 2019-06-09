defmodule Summer.Reader do
  alias Summer.{Connection, Raw, Socket}

  def run(connection, socket) do
    {:ok, msg} = Socket.read(socket)
    IO.write "<< #{msg}"
    parse(connection, msg)
    run(connection, socket)
  end

  defp parse(connection, "PING " <> server) do
    reply(connection, "PONG #{server}")
  end

  defp parse(connection, msg) when is_binary(msg) do
    parse(connection, msg |> String.split(" ", parts: 4))
  end

  # ignoring that last message
  defp parse(_connection, msg) when is_binary(msg), do: nil

  defp parse(connection, [sender, raw, channel, ":" <> message]) do
    if Regex.match?(~r/\d{3}/, raw) do
      Raw.handle(raw, sender, channel, message)
    else
      parse(connection, sender |> parse_sender, raw, channel, message)
    end
  end

  defp parse(connection, [sender, raw, channel, message]) do
    parse_server_msg(connection, sender, raw, channel, message)
  end

  defp parse(connection, sender, "PRIVMSG", channel, message) do
    case Regex.run(~r/^!(\w+)\s*(.*)/, message) do
      [_match, command, args] -> connection |> Connection.handle_command(command, args, sender, channel)
      nil -> connection |> Connection.privmsg(sender.nick, message)
    end
  end

  defp parse(_connection, _sender, _raw, _channel, "VERSION"), do: nil

  # Things like NOTICE + MODE messages from server during boot
  defp parse(_connection, _sender, _raw, _channel, _message), do: nil

  defp parse_server_msg(_connection, _sender, _raw, _channel, _message), do: nil

  defp reply(connection, message) do
    Connection.reply(connection, message)
  end

  defp parse_sender(sender) do
    case sender |> String.split("!") do
      [":" <> nick, hostname] -> %{nick: nick, hostname: hostname}
      [hostname] -> %{hostname: hostname}
    end
  end
end
