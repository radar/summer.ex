defmodule Client.Tip do
  use Ecto.Schema

  schema "tips" do
    field :command, :string
    field :text, :string
  end
end
