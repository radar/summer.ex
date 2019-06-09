defmodule Client.People do
  alias Client.{Person, Repo}

  import Ecto.Query

  def authorize!(nick) do
    case find_person(nick) do
      nil -> nil
      person ->
        person |> Person.changeset(%{authorized: true}) |> Repo.update!
    end
  end

  def authorized?(nick) do
    find_person_query(nick) |> where(authorized: true) |> Repo.one
  end

  defp find_person(nick) do
    find_person_query(nick) |> Repo.one
  end

  defp find_person_query(nick) do
    from(p in Person, where: ilike(p.nick, ^nick)) |> first
  end
end
