defmodule State.Application do

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    :pg2.create(:live_state)

    children = [
      worker(State.Server, []),
      %{
        id: Phoenix.PubSub.PG2,
        start: {Phoenix.PubSub.PG2, :start_link, [:live_state, []]}
      }
    ]

    options = [
      name: State.Supervisor,
      strategy: :one_for_one,
    ]

    { :ok, _pid } = Supervisor.start_link(children, options)
  end

end
