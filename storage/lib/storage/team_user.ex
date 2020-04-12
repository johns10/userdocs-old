defmodule Storage.TeamUser do
  use Ecto.Schema
  import Ecto.Changeset

  @already_exists "ALREADY_EXISTS"

  @primary_key false

  schema "team_member" do
    belongs_to(:user,     Storage.User, primary_key: true)
    belongs_to(:team,     Storage.Team, primary_key: true)
    timestamps()
  end

  def changeset(team_member, params \\ %{}) do
    #IO.puts("applying Changeset")
    team_member
  end

end
