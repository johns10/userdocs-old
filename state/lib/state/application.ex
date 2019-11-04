defmodule State.Application do

  use Application

  def start(_type, _args) do

    import Supervisor.Spec

    children = [
      worker(State.Server, [])
    ]

    options = [
      name: State.Supervisor,
      strategy: :simple_one_for_one,
    ]

    Supervisor.start_link(children, options)
  end
end
