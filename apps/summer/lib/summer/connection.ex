defmodule Summer.Connection do
  use GenServer

  alias Summer.{
    Command,
    Conn,
    Message,
    Reader,
    Writer
  }

  def init(%{
        socket: socket,
        nick: nick,
        channels: channels,
        command_handler: command_handler,
        event_handler: event_handler
      }) do

    {:ok, writer} = GenServer.start_link(Writer, [socket])

    conn = %Conn{
      me: nick,
      writer: writer,
      channels: channels,
      command_handler: command_handler,
      event_handler: event_handler
    }

    Task.start_link(Reader, :run, [conn, socket])

    {:ok, conn}
  end

  def start_link(socket, args) do
    {:ok, connection} = GenServer.start_link(__MODULE__, args |> Map.merge(%{socket: socket}))
    GenServer.cast(connection, :register)
    {:ok, connection}
  end

  def handle_info(:connected, %{channels: channels} = conn) do
    channels |> Enum.each(&(Conn.join(conn, &1)))

    {:noreply, conn}
  end

  def handle_cast(:register, conn) do
    conn |> Conn.register

    Process.send_after(self(), :connected, 10_000)

    {:noreply, conn}
  end
end
