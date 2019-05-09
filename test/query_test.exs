defmodule Hexbot.QueryTest do
  use ExUnit.Case

  import Hexbot.Query

  test "from_hex_pm" do
    list = from_hex_pm("ecto")
    assert length(list) > 0
  end
end
