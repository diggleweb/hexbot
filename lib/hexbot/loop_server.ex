defmodule Hexbot.LoopServer do
  @moduledoc false

  use GenServer
  alias Hexbot.Consumer

  @timeout 0

  def init(state) do
    {:ok, state, @timeout}
  end

  def handle_info(:timeout, %{username: username} = state) do
    loop(username)
    {:noreply, state}
  end

  defp loop(username, nextoffset \\ 0) do
    updates = Nadia.get_updates(offset: nextoffset, limit: 50)

    updates =
      case updates do
        {:ok, updates} ->
          updates

        _ ->
          []
      end

    handle_update = fn update -> update |> Consumer.receive(username) end

    updates
    |> Enum.each(handle_update)

    lastupdate = Enum.at(updates, -1)
    lastoffset = if lastupdate, do: Map.get(lastupdate, :update_id), else: nextoffset - 1

    Process.sleep(1000)
    loop(username, lastoffset + 1)
  end

  def start_link(_opts) do
    {:ok, %Nadia.Model.User{username: username}} = Nadia.get_me()
    GenServer.start_link(__MODULE__, %{username: username}, name: __MODULE__)
  end
end
