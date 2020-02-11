defmodule State.Server do

  use GenServer

  def start_link() do
    { :ok, pid } = GenServer.start_link(__MODULE__, nil, name: __MODULE__)
    :pg2.join(:live_state, pid)
    { :ok, pid }
  end

  def create(type, object, pid \\ __MODULE__) do
    GenServer.call(pid, { :create, type, object })
  end

  def get(type, ids, pid \\ __MODULE__) do
    GenServer.call(pid, { :get, type, ids })
  end

  def update(type, object, pid \\ __MODULE__) do
    GenServer.call(pid, { :update, type, object })
  end

  def delete(type, object, pid \\ __MODULE__) do
    GenServer.call(pid, { :delete, type, object })
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

  def handle_call({ :get_all_related_data, from_type, from_data, to_type }, _from, state) do
    { state, result } = State.State.get_all_related_data(state, from_type, from_data, to_type)
    { :reply, result, state }
  end

  def handle_call({ :create, type, object }, _from, state) do
    { state, result } = State.State.create(state, type, object)
    { :reply, result, state }
  end

  def handle_call({ :update, type, object }, _from, state) do
    { state, result } = State.State.update(state, type, object)
    { :reply, result, state }
  end

  def handle_call({ :delete, type, object }, _from, state) do
    { state, key } = State.State.delete(state, type, object)
    { :reply, key, state }
  end

end
