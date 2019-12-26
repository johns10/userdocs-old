defmodule LiveView.Users do
  use Pow.Ecto.Context,
  user: Storage.Users.User,
  repo: Storage.Repo

  # Use params to look up user and verify password with `MyApp.Users.User.verify_password/2`
  def authenticate(params) do
    IO.puts("Authenticating User")
    IO.inspect(params)
    pow_authenticate(params)
  end


  def create(params) do
    IO.puts("Creating User")
    IO.inspect(params)
    pow_create(params)
  end

  def update(user, params) do
    IO.puts("Updating User")
    IO.inspect(user)
    IO.inspect(params)
    pow_update(user, params)
  end

  def delete(user) do
    IO.puts("Deleting User")
    IO.inspect(user)
    pow_delete(user)
  end

  def get_by(clauses) do
    IO.puts("Getting User by")
    pow_get_by(clauses)
  end

end
