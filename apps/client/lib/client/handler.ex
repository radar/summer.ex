defmodule Client.Handler do
  alias Client.People

  def handle(connection, "botsnack", _parts, me, %{nick: nick} = sender, channel) do
    if People.authorized?(nick) do
      connection |> privmsg_reply(me, sender, channel, "Nom nom. Thanks, #{nick}!")
    else
      connection |> privmsg_reply(me, sender, channel, "Who are you?")
    end
  end

  def handle(connection, "authorize", [user | _rest], me, %{nick: nick} = sender, channel) do
    if radar?(nick) do
      People.authorize!(nick)
    end
  end

  defp radar?(nick) do
    String.downcase(nick) == "radar"
  end

  # Rename to CatchAll?
  use Summer.Handler
end
