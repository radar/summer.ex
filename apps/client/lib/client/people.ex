defmodule Client.People do
  alias Client.{Person, Repo}

  import Ecto.Query

  def authorize!(nick) do
    case find_person(nick) do
      %Person{} = person ->
        person |> Person.changeset(%{authorized: true}) |> Repo.update!()

      _ ->
        nil
    end
  end

  def authorized?(nick) do
    find_person_query(nick) |> where(authorized: true) |> Repo.one()
  end

  def find_or_create(nick) do
    person = find_person(nick)

    case person do
      %Person{} = p -> p
      _ -> create_person(nick)
    end
  end

  defp find_person(nick) do
    find_person_query(nick) |> Repo.one()
  end

  defp find_person_query(nick) do
    from(p in Person, where: ilike(p.nick, ^nick)) |> first
  end

  defp create_person(nick) do
    %Person{nick: nick} |> Repo.insert!()
  end
end
