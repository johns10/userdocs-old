defmodule Storage.Team do
  use Ecto.Schema
  import Ecto.Changeset

  @already_exists "ALREADY_EXISTS"

  schema "team" do
    field :name, :string

    many_to_many(
      :user,
      User,
      join_through: "team_user",
      on_replace: :delete
    )

    timestamps()
  end

  def changeset(team_member, params \\ %{}) do
    #IO.puts("applying Changeset")
    team_member
  end

end
