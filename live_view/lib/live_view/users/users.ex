defmodule LiveView.Users do
  use Pow.Ecto.Context,
  user: Storage.Users.User,
  repo: Storage.Repo

  # Use params to look up user and verify password with `MyApp.Users.User.verify_password/2`
  def authenticate(params) do
    pow_authenticate(params)
  end


  def create(params) do
    pow_create(params)
  end

  def update(user, params) do
    pow_update(user, params)
  end

  def delete(user) do
    pow_delete(user)
  end

  def get_by(clauses) do
    pow_get_by(clauses)
  end

end
