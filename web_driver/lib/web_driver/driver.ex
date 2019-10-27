defmodule WebDriver.Driver do
  use Hound.Helpers

  def new() do
    capabilities = setup()
    Hound.start_session(driver: capabilities)
  end

  def setup() do
    %{
      server: true,
      host: "localhost",
      port: 4444,
      #retry_time: 1000000,
      #genserver_timeout: 75000000000,
      driver: "chrome_driver",
      browserName: "chrome",
      browser: "chrome",
      chromeOptions: %{
          "args" => ["--no-sandbox"],
      }
  }
  end

  def wait_until_available(strategy, selector, retries) do
    h_find_element(strategy, selector, retries)
  end

  #-------------Hound Wrappers-------------------------#

  def h_navigate_to(address) do
    navigate_to(address)
  end

  def h_find_element(strategy, selectors, retries) do
    find_element(strategy, selectors, retries)
  end

  def h_click(element) do
    click(element)
  end

  def h_fill_field(element, input) do
    fill_field(element, input)
  end

end
