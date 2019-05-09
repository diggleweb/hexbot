defmodule Hexbot.Subscribe do
  @moduledoc false

  def fetch do
    url = "https://hex.pm"

    resp =
      HTTPoison.get!(url, [
        {"user-agent",
         "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.131 Safari/537.36"}
      ])

    html = resp.body

    html
    |> Floki.find(".log-body > .container > .row > .col-md-4")
    |> Enum.map(&parse_node/1)
  end

  defp parse_node(node) do
    category =
      node |> Floki.find("h3.log-head") |> hd |> Floki.text() |> String.trim() |> String.upcase()

    packages =
      node
      |> Floki.find("ul > li")
      |> Enum.map(&parse_package_node/1)

    {category, packages}
  end

  defp parse_package_node(node) do
    a_node = node |> Floki.find(".title-container > a") |> hd
    name = a_node |> Floki.text()
    href = a_node |> Floki.attribute("href")
    url = "https://hex.pm#{href}"
    description = node |> Floki.find(".description") |> hd |> Floki.text()

    %{
      name: name,
      url: url,
      description: description
    }
  end
end
