defmodule Client.People do
  alias Client.{Person, Repo}

  import Ecto.Query

  def authorized?(nick) do
    from(p in Person, where: ilike(p.nick, ^nick)) |> first |> Repo.one
  end
end
