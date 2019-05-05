defmodule Hexbot.Commander.PingCommander do
  @moduledoc false

  use Hexbot.Commander

  command(:ping)

  @impl Hexbot.Commander
  def handle(msg) do
    chat = Map.get(msg, :chat)
    chat_id = Map.get(chat, :id)
    msg_id = Map.get(msg, :message_id)
    Nadia.send_message(chat_id, "pong", reply_to_message_id: msg_id)
  end
end
