defmodule Users do
  use Pow.Ecto.Context

  defdelegate authenticate(_params), to: Users.Users

  defdelegate create(_params), to: Users.Users

  defdelegate update(_user, _params), to: Users.Users

  defdelegate delete(_user), to: Users.Users

  defdelegate get_by(_clauses), to: Users.Users
end
