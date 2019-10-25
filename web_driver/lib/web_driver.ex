defmodule WebDriver do

  alias WebDriver.Driver

  defdelegate new(), to: Driver

end
