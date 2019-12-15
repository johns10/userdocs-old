defmodule WebDriver.Server do

  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    { :ok, WebDriver.Driver.new() }
  end

  def handle_call({ :navigate, url }, _from, state) do
    nil = WebDriver.Driver.h_navigate_to(url)
    { :reply, :ok, state }
  end

  def handle_call({ :execute_procedure, procedure }, _from, state) do
    nil = WebDriver.Procedure.execute_procedure(procedure)
    { :reply, :ok, state }
  end

end
