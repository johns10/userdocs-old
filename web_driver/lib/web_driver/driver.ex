defmodule WebDriver.Driver do
  use Hound.Helpers

  def start_link() do
    Agent.start_link(&new/0)
  end

  def new() do
    capabilities = setup()
    Hound.new_session(driver: capabilities)
  end

  def setup() do
    %{
      browserName: "chrome",
      server: true,
      chromeOptions: %{
        "args" => ["--headless", "--disable-gpu"]
    }}
  end
end
