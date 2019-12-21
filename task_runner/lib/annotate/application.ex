defmodule TaskRunner.Application do

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(TaskRunner.Server, [])
    ]

    options = [
      name: TaskRunner.Supervisor,
      strategy: :one_for_one,
    ]

    { :ok, _pid } = Supervisor.start_link(children, options)
  end

end
