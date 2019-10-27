defmodule WebDriverTest do
  use ExUnit.Case
  doctest WebDriver

  test "new creates a session" do
    assert WebDriver.Driver.new()
  end


end
