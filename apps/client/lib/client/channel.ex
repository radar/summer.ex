defmodule Client.Channel do
  use Ecto.Schema

  schema "channels" do
    has_many(:messages, Client.Message)
    field(:name, :string)
    field(:hidden, :boolean)
  end
end
