defmodule State.Server do

  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

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
end
