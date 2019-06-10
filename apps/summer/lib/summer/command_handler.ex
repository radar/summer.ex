defmodule Summer.CommandHandler do
  defmacro __using__(_opts) do
    quote do
      use GenServer
      alias Summer.Connection

      def init(args) do
        {:ok, args}
      end

      def start_link(connection) do
        GenServer.start_link(__MODULE__, connection)
      end

      def privmsg_reply(connection, me, sender, channel, message) do
        reply_to = if channel == me, do: sender.nick, else: channel
        connection |> Connection.privmsg(reply_to, message)
      end

      def handle_cast({:command, command, parts, me, sender, channel}, connection) do
        run_command(connection, command, parts, me, sender, channel)
        {:noreply, connection}
      end

      def run_command(_connection, command, _parts, _me, _sender, _channel) do
        {:unhandled, command}
      end
    end
  end

  def handle(handler, command, parts, me, sender, channel) do
    GenServer.cast(handler, {:command, command, parts, me, sender, channel})
  end
end
