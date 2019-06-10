defmodule Summer.Reader do
  alias Summer.{Parser, Socket}

  def run(conn, socket) do
    {:ok, msg} = Socket.read(socket)
    IO.write("<< #{msg}")
    Task.start_link(fn -> Parser.parse(conn, msg) end)
    run(conn, socket)
  end

end
