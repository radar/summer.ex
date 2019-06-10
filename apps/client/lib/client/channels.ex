defmodule Client.Channels do
  alias Client.{Channel, Repo}

  import Ecto.Query

  def find_or_create(name) do
    channel = from(c in Channel, where: ilike(c.name, ^name))
    |> first
    |> Repo.one

    case channel do
      nil -> create_channel(name)
      c -> c
    end
  end

  defp create_channel(name) do
    %Channel{name: name, hidden: true} |> Repo.insert!
  end
end
