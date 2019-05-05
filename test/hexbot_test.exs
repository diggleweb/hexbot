defmodule HexbotTest do
  use ExUnit.Case
  doctest Hexbot

  test "greets the world" do
    assert Hexbot.hello() == :world
  end
end
