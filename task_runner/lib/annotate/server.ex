defmodule TaskRunner.Server do

  use GenServer

  def start_link() do
    { :ok, pid } = GenServer.start_link(__MODULE__, nil, name: __MODULE__)
    IO.puts("---------------Starting task runner-----------------")
    :pg2.join(:live_state, pid)
    { :ok, pid }
  end

  def init(_) do
    Phoenix.PubSub.subscribe(:live_state, "job")
    { :ok, %{} }
  end

  def handle_info({ command, id, object }, state ) do
    TaskRunner.Subscription.handler(command, id, object, state)
    { :noreply, state }
  end
end
