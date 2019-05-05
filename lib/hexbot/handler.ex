defmodule Hexbot.Handler do
  @moduledoc """
  消息处理单元抽象
  """

  defmacro __using__(_) do
    quote do
      @behaviour Hexbot.Handler
      import Hexbot.Handler

      def registry(msg) do
        if match?(msg), do: handle(msg)
      end

      @impl Hexbot.Handler
      def match?(msg), do: false
      @impl Hexbot.Handler
      def handle(msg), do: :ok

      defoverridable match?: 1
      defoverridable handle: 1
    end
  end

  @callback match?(msg :: Nadia.Model.Message.t()) :: boolean()
  @callback handle(msg :: Nadia.Model.Message.t()) :: :ok
end
