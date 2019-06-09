defmodule Summer.Handler do
  defmacro __using__(_opts) do
    quote do
      alias Summer.Connection

      def handle(_connection, _command, _parts, _sender, _channel), do: nil

      def privmsg_reply(connection, me, sender, channel, message) do
        reply_to = if channel == me, do: sender.nick, else: channel
        connection |> Connection.privmsg(reply_to, message)
      end
    end
  end
end
