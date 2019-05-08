defmodule Hexbot.Commander.SubscribeCommander do
  @moduledoc false

  use Hexbot.Commander

  command(:subscribe)

  @impl Hexbot.Commander
  def handle(msg) do
    %{message_id: message_id, chat: %{id: chat_id}} = msg

    text = "Not implemented 😆"
    Nadia.send_message(chat_id, text, reply_to_message_id: message_id)
    :ok
  end
end
