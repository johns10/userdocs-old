defmodule WebDriverTest do
  use ExUnit.Case
  doctest WebDriver

  test "greets the world" do
    assert WebDriver.hello() == :world
  end
end
