defmodule State do

  alias State.Server

  def new_state() do
    { :ok, pid } = Server.start_link()
    pid
  end

  def get(pid, type, keys, includes) do
    GenServer.call(pid, { :get, type, keys, includes })
  end

  def create(pid, type, key, value) do
    GenServer.call(pid, { :create, type, key, value })
  end

  def update(pid, type, key, value) do
    GenServer.call(pid, { :update, type, key, value })
  end

end
