defmodule Hexbot do
  @moduledoc false

  use Application
  alias Hexbot.Commander.{PingCommander}

  def start(_type, _args) do
    filters = [commanders: [PingCommander]]

    children = [
      {Hexbot.FilterManager, filters},
      {Hexbot.LoopServer, []}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
