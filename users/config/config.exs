import Config

config :users, :pow,
  user: Users.Users.User,
  repo: Storage.Repo

config :storage, Storage.Repo,
  database: "storage_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5433"
