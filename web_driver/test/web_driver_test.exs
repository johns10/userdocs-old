defmodule WebDriverTest do
  use ExUnit.Case
  doctest WebDriver
  use Hound.Helpers

  '''
  test "new creates a session" do
    assert WebDriver.Driver.new()
  end
  '''

  hound_session()


end
