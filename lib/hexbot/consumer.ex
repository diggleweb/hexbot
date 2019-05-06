defmodule Hexbot.Consumer do
  @moduledoc false

  use DynamicSupervisor
  alias Hexbot.{FilterManager, Query}

  def start_link(_opts) do
    DynamicSupervisor.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  defp dispatch_commander(msg, username) do
    text = Map.get(msg, :text)

    applying = fn commander ->
      name = commander.command()
      match = text == name || text == "#{name}@#{username}"
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

  def receive(update, username) do
    inline_query = Map.get(update, :inline_query)
    msg = Map.get(update, :message)

    dispatch_msg = fn ->
      msg
      |> dispatch_commander(username)
      |> dispatch_handler
    end

    dispatch_search = fn ->
      id = Map.get(inline_query, :id)
      keywords = Map.get(inline_query, :query)
      results = Query.from_hex_pm(keywords)
      Nadia.answer_inline_query(id, results)
    end

    if msg, do: DynamicSupervisor.start_child(__MODULE__, {Task, dispatch_msg})
    if inline_query, do: DynamicSupervisor.start_child(__MODULE__, {Task, dispatch_search})
  end
end
