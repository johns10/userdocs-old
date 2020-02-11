defmodule Storage.Project do
  use Ecto.Schema
  import Ecto.Changeset
  alias Storage.Helpers

  schema "project" do
    field :provisional_id,  :string,  virtual: true
    field :changeset,       :map,     virtual: true
    field :storage_status,  :string,  virtual: true

    field :name,            :string
    field :base_url,        :string
    field :project_type,    :string
    field :record_status,   :string

    field :team_id,         :integer

    belongs_to  :team, Storage.Team, foreign_key: :id, references: :team_id, define_field: false

    timestamps()
  end

  def form_changeset(project, params \\ %{}, assoc \\ %{}) do
    #IO.puts("Applying Project Changeset")
    project
    |> cast(params, [ :id, :name, :base_url, :project_type, :record_status, :storage_status, :team_id ])
    |> Helpers.validate_assoc(:team, assoc.team)
    |> validate_required([ :name, :base_url, :project_type ])
  end

end
