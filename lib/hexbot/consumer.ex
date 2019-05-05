defmodule Hexbot.Consumer do
  @moduledoc false

  use DynamicSupervisor
  alias Hexbot.FilterManager

  def start_link(_opts) do
    DynamicSupervisor.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  defp dispatch_commander(msg) do
    text = Map.get(msg, :text)

    applying = fn commander ->
      name = commander.command()
      match = text == name || text == "#{name}@elixir_hexbot"
      if match, do: commander.handle(msg)
    end

    if text do
      commanders = FilterManager.commanders()
      Enum.each(commanders, applying)
    end

    msg
  end

  defp dispatch_handler(msg) do
    applying = fn handler ->
      if handler.match?(msg), do: handler.handle(msg)
    end

    handlers = FilterManager.handlers()
    Enum.each(handlers, applying)

    msg
  end

  def receive(msg) do
    dispatch = fn ->
      msg
      |> dispatch_commander
      |> dispatch_handler
    end

    DynamicSupervisor.start_child(__MODULE__, {Task, dispatch})
  end
end
