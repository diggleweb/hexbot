defmodule Hexbot.FilterManager do
  @moduledoc false

  use Agent

  def start_link(opts) do
    commanders = Keyword.get(opts, :commanders, [])
    data = [commanders: commanders]
    Agent.start_link(fn -> data end, name: __MODULE__)
  end

  def commanders do
    Agent.get(__MODULE__, fn filters -> Keyword.get(filters, :commanders, []) end)
  end
end
