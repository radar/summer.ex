defmodule Summer.Connection do
  use GenServer

  alias Summer.{
    CommandHandler,
    Connection,
    Message,
    MessageHandler,
    Reader,
    Writer
  }

  def init(%{
        socket: socket,
        nick: nick,
        command_handler: command_handler,
        message_handler: message_handler
      }) do
    {:ok, command_handler} = command_handler.start_link(self())
    {:ok, message_handler} = message_handler.start_link(self())
    Task.start_link(Reader, :run, [self(), socket])

    {:ok, writer} = GenServer.start_link(Writer, [socket])

    connection = %{
      nick: nick,
      writer: writer,
      command_handler: command_handler,
      message_handler: message_handler
    }

    {:ok, connection}
  end

  def start_link(socket, %{nick: nick} = args) do
    {:ok, connection} = GenServer.start_link(__MODULE__, args |> Map.merge(%{socket: socket}))
    Connection.register(connection, %{nick: nick})
    {:ok, connection}
  end

  def register(connection, args) do
    GenServer.cast(connection, {:register, args})
  end

  def reply(connection, message) do
    GenServer.cast(connection, {:reply, message})
  end

  def privmsg(connection, dest, message) do
    GenServer.cast(connection, {:privmsg, dest, message})
  end

  def handle_command(connection, command, args, sender, channel) do
    GenServer.cast(connection, {:command, command, args, sender, channel})
  end

  def handle_incoming_message(connection, sender, channel, text) do
    GenServer.cast(connection, {:incoming_message, sender, channel, text})
  end

  def handle_cast({:register, %{nick: nick}}, %{writer: writer} = state) do
    [
      "USER #{nick} #{nick} #{nick} #{nick}",
      "NICK #{nick}"
    ]
    |> Enum.each(&write(writer, :normal, &1))

    {:noreply, state}
  end

  def handle_cast({:reply, message}, %{writer: writer} = state) do
    write(writer, :normal, message)
    {:noreply, state}
  end

  def handle_cast({:privmsg, dest, message}, %{writer: writer} = state) do
    write(writer, :privmsg, dest, message)
    {:noreply, state}
  end

  def handle_cast(
        {:command, command, args, sender, channel},
        %{command_handler: command_handler, nick: me} = state
      ) do
    CommandHandler.handle(command_handler, command, args, me, sender, channel)
    {:noreply, state}
  end

  def handle_cast(
        {:incoming_message, sender, channel, text},
        %{message_handler: message_handler, nick: me} = state
      ) do
    message = %Message{
      type: "privmsg",
      sender: sender,
      channel: channel,
      text: text
    }

    MessageHandler.handle(message_handler, me, message)
    {:noreply, state}
  end

  defp write(writer, type, message) do
    Writer.write(writer, type, message)
  end

  defp write(writer, type, dest, message) do
    Writer.write(writer, type, dest, message)
  end
end
