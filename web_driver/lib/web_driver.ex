defmodule WebDriver do

  alias WebDriver.Driver

  defdelegate get_screenshots(login_procedure, pages) do
    WebDriver.Procedure.execute_procedure(login_procedure)
    WebDriver.Page.process_pages(pages)
  end

end
