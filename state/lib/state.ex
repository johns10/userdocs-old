defmodule State do

  alias State.Server

  defdelegate get(type, keys, includes), to: State.Server

  defdelegate create(type, key, value), to: State.Server

  defdelegate update(type, key, value), to: State.Server
'''
  def new() do
    { :ok, pid } = Server.start_link()
    pid
  end

  def get(_, type, keys, includes) do
    GenServer.call(__MODULE__, { :get, type, keys, includes })
  end

  def create(pid, type, key, value) do
    GenServer.call(pid, { :create, type, key, value })
  end

  def update(pid, type, key, value) do
    GenServer.call(pid, { :update, type, key, value })
  end
'''
end
