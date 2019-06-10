defmodule Client.CommandHandler do
  alias Summer.{Command, Conn, Message}

  alias Client.{People, Tip, Tips}

  def handle(conn, %Command{name: "botsnack", args: _parts, message: %Message{sender: %{nick: nick}} = message}) do
    if People.authorized?(nick) do
      conn |> Conn.privmsg_reply(message, "Nom nom. Thanks, #{nick}!")
    else
      conn |> Conn.privmsg_reply(message, "Who are you?")
    end
  end

  def handle(conn, %Command{name: "authorize", args: [new_authorization | _rest], message: %{sender: %{nick: nick} = message}}) do
    if radar?(nick) do
      People.authorize!(new_authorization)

      conn |> Conn.privmsg_reply(message, "#{new_authorization} is now authorized to (ab)use me.")
    end
  end

  def handle(conn, %Command{name: name, message: message}) do
    case Tips.find(name) do
      %Tip{} = tip -> conn |> Conn.privmsg_reply(message, tip.text)
      nil -> nil
    end
  end

  defp radar?(nick) do
    String.downcase(nick) == "radar"
  end
end
