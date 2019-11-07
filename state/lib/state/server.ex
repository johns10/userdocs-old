defmodule State.Server do

  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def create(type, key, value, pid \\ __MODULE__) do
    GenServer.call(pid, { :create, type, key, value })
  end

  def get(type, keys, includes, pid \\ __MODULE__) do
    GenServer.call(pid, { :get, type, keys, includes })
  end

  def update(type, key, value, pid \\ __MODULE__) do
    GenServer.call(pid, { :update, type, key, value })
  end

  def delete(type, key, pid \\ __MODULE__) do
    GenServer.call(pid, { :delete, type, key })
  end

  #################### Server API #########################

  def init(_) do
    { :ok, State.State.new_state() }
  end

  def handle_call({ :get, type, keys, includes }, _from, state) do
    { state, result } = State.State.get(state, type, keys, includes)
    { :reply, result, state }
  end

  def handle_call({ :create, type, key, value }, _from, state) do
    { state, result } = State.State.create(state, type, key, value)
    { :reply, result, state }
  end

  def handle_call({ :update, type, key, value }, _from, state) do
    { state, result } = State.State.update(state, type, key, value)
    { :reply, result, state }
  end

  def handle_call({ :delete, type, key }, _from, state) do
    { state, key } = State.State.delete(state, type, key)
    { :reply, key, state }
  end

end
