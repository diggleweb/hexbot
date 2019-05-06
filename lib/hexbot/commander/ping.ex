defmodule Hexbot.Commander.PingCommander do
  @moduledoc false

  use Hexbot.Commander

  command(:ping)

  @impl Hexbot.Commander
  def handle(msg) do
    %{message_id: message_id, chat: %{id: chat_id}} = msg

    Nadia.send_message(chat_id, "pong", reply_to_message_id: message_id)
    :ok
  end
end
