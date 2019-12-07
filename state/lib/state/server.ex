defmodule State.Server do

  use GenServer

  def start_link() do
    { :ok, pid } = GenServer.start_link(__MODULE__, nil, name: __MODULE__)
    :pg2.join(:live_state, pid)
    { :ok, pid }
  end

  def create(type, key, value, pid \\ __MODULE__) do
    GenServer.call(pid, { :create, type, key, value })
  end

  def get(type, keys, pid \\ __MODULE__) do
    GenServer.call(pid, { :get, type, keys })
  end

  def update(type, key, value, pid \\ __MODULE__) do
    GenServer.call(pid, { :update, type, key, value })
  end

  def delete(type, key, pid \\ __MODULE__) do
    GenServer.call(pid, { :delete, type, key })
  end

  def get_all_related_data(from_type, from_ids, to_type, pid \\ __MODULE__) do
    GenServer.call(pid, { :get_all_related_data, from_type, from_ids, to_type })
  end

  #################### Server API #########################

  def init(_) do
    { :ok, State.State.new_state() }
  end

  def handle_call({ :get, type, keys }, _from, state) do
    { state, result } = State.State.get(state, type, keys)
    { :reply, result, state }
  end

  def handle_call({ :get_all_related_data, from_type, from_ids, to_type }, _from, state) do
    { state, result } = State.State.get_all_related_data(state, from_type, from_ids, to_type)
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
