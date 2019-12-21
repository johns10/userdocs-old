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
      #chromeOptions: %{
      #    "args" => ["headless"],
      #}
  }
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

  def h_execute_script(script_function, function_args) do
    execute_script(script_function, function_args)
  end
  def h_execute_script(script_function) do
    execute_script(script_function, [])
  end

  def h_element_displayed?(request = { status, element }) do
    { element_displayed?(element), element }
  end
  def h_element_displayed?(element) do
    element_displayed?(element)
  end

  def h_take_screenshot() do
    take_screenshot()
  end

  def h_set_window_size(width, height) do
    set_window_size(current_window_handle(), width, height)
  end
end
