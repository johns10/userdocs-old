defmodule Storage.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    pow_user_fields()

    many_to_many(
      :team,
      Storage.Team,
      join_through: "team_member",
      on_replace: :delete
    )

    timestamps()
  end
end
