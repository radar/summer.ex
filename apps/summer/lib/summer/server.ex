defmodule Summer.Server do
  use GenServer
  alias Summer.{Connection, Socket}

  def init(%{host: host, port: port} = args) do
    {:ok, socket} = Socket.connect(host, port)
    Connection.start_link(socket, args)
    {:ok, args}
  end

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end
end
