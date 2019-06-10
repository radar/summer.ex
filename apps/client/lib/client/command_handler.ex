defmodule Client.CommandHandler do
  alias Client.{People, Tip, Tips}

  def run_command(connection, "botsnack", _parts, me, %{nick: nick} = sender, channel) do
    if People.authorized?(nick) do
      connection |> privmsg_reply(me, sender, channel, "Nom nom. Thanks, #{nick}!")
    else
      connection |> privmsg_reply(me, sender, channel, "Who are you?")
    end
  end

  def run_command(
        connection,
        "authorize",
        [new_authorization | _rest],
        me,
        %{nick: nick} = sender,
        channel
      ) do
    if radar?(nick) do
      People.authorize!(new_authorization)

      connection
      |> privmsg_reply(
        me,
        sender,
        channel,
        "#{new_authorization} is now authorized to (ab)use me."
      )
    end
  end

  def run_command(connection, command, _args, me, sender, channel) do
    case Tips.find(command) do
      %Tip{} = tip -> connection |> privmsg_reply(me, sender, channel, tip.text)
      nil -> nil
    end
  end

  defp radar?(nick) do
    String.downcase(nick) == "radar"
  end

  # Rename to CatchAll?
  use Summer.CommandHandler
end
