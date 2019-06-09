defmodule Client.Handler do
  def handle(connection, "botsnack", _parts, me, %{nick: nick} = sender, channel) do
    connection |> privmsg_reply(me, sender, channel, "Nom nom. Thanks, #{nick}!")
  end

  # Rename to CatchAll?
  use Summer.Handler
end
