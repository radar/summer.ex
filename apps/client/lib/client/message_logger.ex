defmodule Client.MessageLogger do
  alias Client.{Channels, Messages, People}
  alias Summer.Message

  def log(:privmsg, %Message{sender: %{nick: nick}, channel: channel_name, text: text}) do
    create_message(%{
      type: "privmsg",
      channel_name: channel_name,
      nick: nick,
      text: text
    })
  end

  def log(:join, joiner, channel_name) do
    create_message(%{
      type: "join",
      channel_name: channel_name,
      nick: joiner,
      text: "has joined",
    })
  end

  def log(:part, parter, channel_name) do
    create_message(%{
      type: "part",
      channel_name: channel_name,
      nick: parter,
      text: "has parted",
    })
  end

  defp create_message(%{
    type: type,
    channel_name: channel_name,
    nick: nick,
    text: text,
  }) do
    channel_name = String.replace(channel_name, "#", "")

    channel = Channels.find_or_create(channel_name)
    person = People.find_or_create(nick)

    Messages.create(%{
      hidden: channel.hidden,
      type: type,
      channel: channel,
      person: person,
      text: text
    })
  end
end
