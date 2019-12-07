defmodule PubSub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    :pg2.create :live_state

    children = [
      %{
        id: Phoenix.PubSub.PG2,
        start: {Phoenix.PubSub.PG2, :start_link, [:live_state, []]}
      }
    ]

    opts = [strategy: :one_for_one, name: PubSub.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
