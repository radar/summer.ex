defmodule Summer.Connection do
  use GenServer
  alias Summer.Socket

  def init(%{host: host, port: port, nick: nick, handler: handler}) do
    {:ok, socket} = Socket.connect(host, port)
    Task.start_link(Summer.Reader, :run, [self(), socket])

    {:ok, writer} = GenServer.start_link(Summer.Writer, [socket])
    {:ok, %{nick: nick, writer: writer, handler: handler}}
  end

  def start_link(%{nick: nick} = args) do
    {:ok, connection} = GenServer.start_link(__MODULE__, args)
    Summer.Connection.register(connection, %{nick: nick})
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

  def handle_cast({:register, %{nick: nick}}, %{writer: writer} = state) do
    [
      "USER #{nick} #{nick} #{nick} #{nick}",
      "NICK #{nick}"
    ] |> Enum.each(&(write(writer, :normal, &1)))
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

  def handle_cast({:command, command, args, sender, channel}, %{handler: handler, nick: me} = state) do
    handler.handle(self(), command, args, me, sender, channel)
    {:noreply, state}
  end

  defp write(writer, type, message) do
    Summer.Writer.write(writer, type, message)
  end

  defp write(writer, type, dest, message) do
    Summer.Writer.write(writer, type, dest, message)
  end
end
