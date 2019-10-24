defmodule PageGetterTest do
  use ExUnit.Case
  doctest PageGetter

  test "greets the world" do
    assert PageGetter.hello() == :world
  end
end
