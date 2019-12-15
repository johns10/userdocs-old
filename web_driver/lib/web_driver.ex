defmodule WebDriver do

  alias WebDriver.Driver

  def get_screenshots(login_procedure, pages) do
    WebDriver.Procedure.execute_procedure(login_procedure)
    WebDriver.Page.process_pages(pages)
  end

  """

  defdelegate execute_procedure(procedure), to: WebDriver.Procedure

  defdelegate navigate(url), to: WebDriver.Server

  """

  def navigate(pid, url) do
    GenServer.call(pid, { :navigate, url })
  end

  def execute_procedure(procedure, pid) do
    GenServer.call(pid, { :execute_procedure, procedure })
  end

end
