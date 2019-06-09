defmodule Summer.Socket do
  def connect(host, port) do
    opts = [:binary, active: false, packet: :line]
    :gen_tcp.connect(host |> to_charlist, port, opts)
  end

  def read(socket) do
    :gen_tcp.recv(socket, 0)
  end

  def reply(socket, message) do
    :gen_tcp.send(socket, "#{message}\r\n")
  end
end
