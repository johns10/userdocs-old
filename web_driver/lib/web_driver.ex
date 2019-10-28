defmodule WebDriver do

  alias WebDriver.Driver

  def get_screenshots(login_procedure, pages) do
    WebDriver.Procedure.execute_procedure(login_procedure)
    WebDriver.Page.process_pages(pages)
  end

end
