defmodule Client.MessageHandler do
  use Summer.MessageHandler

  alias Client.MessageLogger

  def handle_message(
        connection,
        me,
        message
      ) do
    MessageLogger.log(message)
  end

end
