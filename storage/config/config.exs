import Config

config :storage, ecto_repos: [Storage.Repo]

config :storage, Storage.Repo,
  database: "storage_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5433"

config :storage, :pow,
  user: Storage.Users.User,
  repo: Storage.Repo,
  web_module: LiveViewWeb
