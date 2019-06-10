defmodule Client.Message do
  use Ecto.Schema
  alias Client.{Channel, Person}

  schema "messages" do
    belongs_to(:channel, Channel)
    belongs_to(:person, Person)

    field(:text, :string)
    field(:type, :string)
    field(:created_at, :naive_datetime)
    field(:hidden, :boolean)
  end

  def changeset(message, params \\ %{}) do
    message
    |> Ecto.Changeset.cast(params, [:text, :type])
    |> Ecto.Changeset.put_assoc(:channel, params.channel)
    |> Ecto.Changeset.put_assoc(:person, params.person)
  end
end
