defmodule State do

  defdelegate get(type, keys), to: State.Server

  defdelegate get_all_related_data(from_type, from_data, to_type), to: State.Server

  defdelegate create(type, object), to: State.Server

  defdelegate update(type, object), to: State.Server

  defdelegate delete(type, object), to: State.Server
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
