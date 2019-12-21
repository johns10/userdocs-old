defmodule Job.Server do

  use GenServer

  def start_link() do
    { :ok, pid } = GenServer.start_link(__MODULE__, nil, name: __MODULE__)
    IO.puts("---------------Starting task runner-----------------")
    :pg2.join(:live_state, pid)
    { :ok, pid }
  end

  def init(_) do
    Phoenix.PubSub.subscribe(:live_state, "job")
    { :ok, %{ job: %{} } }
  end

  def handle_info({ :job, :create, id, object }, state ) do
    state = Subscription.Handler.handle(:job, :create, id, object, state)
    Job.Builder.build(id, object)
    { :noreply, state }
  end
end
