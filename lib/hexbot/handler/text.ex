defmodule Hexbot.Handler.TextHandler do
  @moduledoc """
  文本消息处理（放置最后）
  """

  use Hexbot.Handler

  @impl Hexbot.Handler
  def match?(msg) do
    Map.get(msg, :text)
  end

  @impl Hexbot.Handler
  def handle(_msg) do
    # text = Map.get(msg, :text)
    # IO.puts("Text message: #{text}")
  end
end
