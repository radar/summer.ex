defmodule Summer.Writer do
  use GenServer

  def init([socket]) do
    {:ok, socket}
  end

  def write(writer, type, message) do
    GenServer.cast(writer, {:write, type, message})
  end

  def write(writer, type, dest, message) do
    GenServer.cast(writer, {:write, type, dest, message})
  end

  def handle_cast({:write, :normal, message}, socket) do
    reply(socket, message)
    {:noreply, socket}
  end

  def handle_cast({:write, :privmsg, dest, message}, socket) do
    reply(socket, "PRIVMSG #{dest} :#{message}")
    {:noreply, socket}
  end

  def reply(socket, message) do
    IO.puts ">> #{message}"
    :gen_tcp.send(socket, "#{message}\r\n")
  end
end
