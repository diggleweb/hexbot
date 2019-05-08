defmodule Hexbot.Subscribe do
  @moduledoc false

  def fetch do
    url = "https://hex.pm"
    resp = HTTPoison.get!(url)
    html = resp

    html
    |> Floki.find(".container > .row > .cow-md-4")
    |> Enum.map(&parse_node/1)
  end

  defp parse_node(_li_node) do
    []
  end
end
