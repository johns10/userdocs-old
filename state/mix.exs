defmodule State.MixProject do
  use Mix.Project

  def project do
    [
      app: :state,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: { State.Application, [] },
      mod: { PubSub.Application, [] },
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_pubsub, "~> 1.0"},
      {:state_handlers, path: "../state_handlers"},
      {:storage, path: "../storage"}
    ]
  end
end
