defmodule Summer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children =
      Application.get_env(:summer, :servers)
      |> Enum.map(fn server ->
        {Summer.Server, server}
      end)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Summer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
