defmodule Hexbot.Commander.StartCommander do
  @moduledoc false

  use Hexbot.Commander

  command(:start)

  @impl Hexbot.Commander
  def handle(msg) do
    %{chat: %{id: chat_id}} = msg

    text = "At me, and tell me the Hex package name (*ﾟ∀ﾟ*)"
    Nadia.send_message(chat_id, text)
    :ok
  end
end
