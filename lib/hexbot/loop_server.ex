defmodule Hexbot.LoopServer do
  @moduledoc false

  use GenServer
  alias Hexbot.FilterManager

  @timeout 5000

  def init(_) do
    {:ok, %{}, @timeout}
  end

  def handle_info(:timeout, state) do
    loop()
    {:noreply, state}
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

  def handle_update(update) do
    msg = Map.get(update, :message)

    msg
    |> dispatch_commander
    |> dispatch_handler
  end

  defp loop do
    updates = Nadia.get_updates()

    updates =
      case updates do
        {:ok, updates} ->
          updates

        _ ->
          []
      end

    updates
    |> Enum.each(&handle_update/1)

    Process.sleep(1000)
    loop()
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end
end
