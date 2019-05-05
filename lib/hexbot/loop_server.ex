defmodule Hexbot.LoopServer do
  @moduledoc false

  use GenServer
  alias Hexbot.Consumer

  @timeout 5000

  def init(_) do
    {:ok, %{}, @timeout}
  end

  def handle_info(:timeout, state) do
    loop()
    {:noreply, state}
  end

  def handle_update(update) do
    msg = Map.get(update, :message)
    msg |> Consumer.receive()
  end

  defp loop(nextoffset \\ 0) do
    updates = Nadia.get_updates(offset: nextoffset, limit: 50)

    updates =
      case updates do
        {:ok, updates} ->
          updates

        _ ->
          []
      end

    updates
    |> Enum.each(&handle_update/1)

    lastupdate = Enum.at(updates, -1)
    lastoffset = if lastupdate, do: Map.get(lastupdate, :update_id), else: nextoffset - 1

    Process.sleep(1000)
    loop(lastoffset + 1)
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end
end
