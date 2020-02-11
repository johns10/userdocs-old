defmodule Storage.Version do
  use Ecto.Schema
  import Ecto.Changeset
  alias Storage.Helpers

  schema "version" do
    field :storage_status,  :string,  virtual: true

    field :name,            :string
    field :record_status,   :string

    field :project_id,      :integer

    belongs_to  :project, Storage.Project, foreign_key: :project_id, references: :id, define_field: false
    has_many    :step,    Storage.Step

    timestamps()
  end

  def form_changeset(version, params \\ %{}, assoc \\ %{}) do
    #IO.puts("Applying Project Changeset")
    version
    |> cast(params, [ :name, :storage_status, :record_status, :project_id, :id ])
    |> Helpers.assign_provisional_id(params["id"])
    |> Helpers.validate_assoc(:project, assoc.project)
    |> validate_required([ :name ])
  end
end
