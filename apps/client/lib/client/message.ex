defmodule Client.Message do
  use Ecto.Schema
  alias Client.{Channel, Person}

  schema "messages" do
    belongs_to :channel, Channel
    belongs_to :person, Person

    field :text, :string
    field :type, :string
    field :created_at, :naive_datetime
    field :hidden, :boolean
  end
end
