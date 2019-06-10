defmodule Summer.MessageHandler do
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

      def handle_cast({:message, me, message}, connection) do
        handle_message(connection, me, message)
        {:noreply, connection}
      end
    end
  end

  def handle(handler, me, message) do
    GenServer.cast(handler, {:message, me, message})
  end
end
