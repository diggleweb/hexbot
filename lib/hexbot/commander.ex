defmodule Hexbot.Commander do
  @moduledoc """
  指令抽象
  """

  defmacro __using__(_otps) do
    quote do
      @behaviour Hexbot.Commander
      import Hexbot.Commander

      def command, do: :default

      defoverridable command: 0
    end
  end

  defmacro command(name) do
    name_s = "/#{Atom.to_string(name)}"

    quote do
      def command, do: unquote(name_s)
    end
  end

  @callback handle(msg :: Nadia.Model.Message.t()) :: :ok
end
