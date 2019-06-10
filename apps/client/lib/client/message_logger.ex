defmodule Client.MessageLogger do
  alias Client.{Channels, Messages, People}
  alias Summer.Message

  def log(%Message{sender: %{nick: nick}, channel: channel_name, text: text}) do
    channel_name = String.replace(channel_name, "#", "")

    channel = Channels.find_or_create(channel_name)
    person = People.find_or_create(nick)

    Messages.create(%{
      type: "privmsg",
      channel: channel,
      person: person,
      text: text,
      hidden: channel.hidden
    })
  end
end
