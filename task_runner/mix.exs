defmodule TaskRunner.MixProject do
  use Mix.Project

  def project do
    [
      app: :task_runner,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: { TaskRunner.Application, [] },
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:state, path: "../state"},
      {:script, path: "../script"},
      {:web_driver, path: "../web_driver"},
      {:uuid, "~> 1.1"},
      {:phoenix_pubsub, "~> 1.0"}
    ]
  end
end
