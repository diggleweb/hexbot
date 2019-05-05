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
    msg |> Consumer.receive
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
