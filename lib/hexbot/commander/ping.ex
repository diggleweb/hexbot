defmodule Hexbot.Commander.PingCommander do
  @moduledoc false

  use Hexbot.Commander

  command(:ping)

  @impl Hexbot.Commander
  def handle(_msg) do
    IO.puts("Handling #{command()}")
  end
end
