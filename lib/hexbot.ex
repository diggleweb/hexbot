defmodule Hexbot do
  @moduledoc false

  use Application
  alias Hexbot.Commander.{PingCommander}
  alias Hexbot.Handler.{TextHandler}

  def start(_type, _args) do
    filters = [commanders: [PingCommander], handlers: [TextHandler]]

    children = [
      {Hexbot.FilterManager, filters},
      {Hexbot.LoopServer, []},
      {Hexbot.Consumer, []}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
