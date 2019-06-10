defmodule Summer.Parser do
  alias Summer.{Conn, Command, Message, Raw}

  def parse(conn, "PING " <> server) do
    conn |> Conn.reply("PONG #{server}")
  end

  def parse(conn, msg) when is_binary(msg) do
    case msg |> String.split(" ", parts: 4) do
      [sender, raw, channel, text] -> conn |> parse(sender, raw, channel, text)
      # JOIN / PART events
      [sender, raw, channel] -> conn |> parse(sender, raw, channel)
    end
  end

  defp parse(conn, sender, raw, channel, ":" <> text) do
    text = String.trim(text)

    if Regex.match?(~r/\d{3}/, raw) do
      Raw.handle(raw, sender, channel, text)
    else
      parse(conn, sender |> parse_sender, raw, channel, text)
    end
  end

  defp parse(conn, sender, "PRIVMSG", channel, text) do
    message = %Message{
      sender: sender,
      channel: channel,
      text: text,
    }
    case Regex.run(~r/^!(\w+)\s*(.*)/, text) do
      nil ->
        conn |> Conn.handle_event(:privmsg, message)
      [_match, command, args] ->
        command = %Command{
          name: command,
          args: args,
          message: message
        }
        conn |> Conn.handle_command(command)
    end
  end

  defp parse(_conn, _sender, _raw, _channel, "VERSION"), do: nil

  # Things like NOTICE + MODE messages from server during boot
  defp parse(conn, sender, raw, channel, text) do
    parse_server_msg(conn, sender, raw, channel, text)
  end

  defp parse(conn, sender, "JOIN", channel) do
    conn |> Conn.handle_event(:join, sender, channel)
  end

  defp parse_server_msg(_conn, _sender, _raw, _channel, _message), do: nil

  defp parse_sender(sender) do
    case sender |> String.split("!") do
      [":" <> nick, hostname] -> %{nick: nick, hostname: hostname}
      [hostname] -> %{hostname: hostname}
    end
  end
end
