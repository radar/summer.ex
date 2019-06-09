defmodule Client.Person do
  use Ecto.Schema

  schema "people" do
    field :nick, :string
    field :authorized, :boolean
    field :created_at, :naive_datetime
  end

  def changeset(person, params \\ %{}) do
    person
    |> Ecto.Changeset.cast(params, [:authorized])
  end

end
