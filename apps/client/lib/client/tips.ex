defmodule Client.Tips do
  alias Client.{Repo, Tip}
  import Ecto.Query

  def find(command) do
    from(t in Tip, where: t.command == ^command)
    |> first
    |> Repo.one
  end
end
