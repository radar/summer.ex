defmodule Client.Messages do
  alias Client.{Message, Repo}

  def create(params) do
    %Message{} |> Message.changeset(params) |> Repo.insert!
  end
end
