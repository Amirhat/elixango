defmodule ElixangoTest do
  use ExUnit.Case
  doctest Elixango

  test "greets the world" do
    assert Elixango.hello() == :world
  end
end
