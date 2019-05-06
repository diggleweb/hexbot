defmodule Hexbot.Query do
  @moduledoc """
  Bot 内联查询和 Hex 包搜索
  """

  require Protocol
  alias Nadia.Model.InlineQueryResult.Article
  alias Nadia.Model.InputMessageContent.Text

  Protocol.derive(Jason.Encoder, Text, only: [:message_text])

  def from_hex_pm(keywords) do
    url = "https://hex.pm/packages?search=#{keywords}&sort=recent_downloads"
    resp = HTTPoison.get!(url)
    html = resp.body

    html
    |> Floki.find(".package-list > ul > li")
    |> Enum.map(&parse_node/1)
  end

  defp parse_node(li_node) do
    a_node = hd(Floki.find(li_node, "a"))

    name = a_node |> Floki.text()
    href = a_node |> Floki.attribute("href") |> hd
    version = li_node |> Floki.find(".version") |> hd |> Floki.text()
    description = li_node |> Floki.find("p:last-child") |> hd |> Floki.text()

    %Article{
      id: name,
      title: "#{name} #{version}",
      description: description,
      input_message_content: %Text{message_text: "https://hex.pm#{href}"}
    }
  end
end
