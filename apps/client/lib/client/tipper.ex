defmodule Client.Tipper do
  alias Summer.Message

  alias Client.{People, Tips}

  @silenced_channels [
    "#ruby",
    "#ruby-ops",
    "#ruby-offtopic",
    "#ruby-community",
    "#ruby-banned",
    "#elixir-lang"
  ]

  def check(%Message{sender: %{nick: nick}, channel: channel} = message) do
    unless channel in @silenced_channels do
      if People.authorized?(nick), do: tip(message)
    end
  end


  # %Message{sender: sender, channel: channel, text: text}
  defp tip(_message) do
  end
end
