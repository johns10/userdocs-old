defmodule Users.Users do
  use Pow.Ecto.Context

  def authenticate(_params) do
    IO.puts("Authenticating User")
    {:error, :not_implemented}
  end
  def create(_params) do
    IO.puts("Creating User")
    {:error, :not_implemented}
  end

  def update(_user, _params) do
    IO.puts("Updating User")
    {:error, :not_implemented}
  end

  def delete(_user) do
    IO.puts("Deleting User")
    {:error, :not_implemented}
  end

  def get_by(_clauses) do
    IO.puts("Getting by")
    {:error, :not_implemented}
  end
end
