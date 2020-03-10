defmodule Storage.Content do
  use Ecto.Schema

  import Ecto.Changeset

  alias Storage.Helpers

  schema "element" do
    field :storage_status,  :string,  virtual: true

    field :record_status,   :string

    field :name,            :string
    field :description,     :string
    field :team_id,         :integer

    belongs_to  :team, Storage.Team, foreign_key: :id, references: :team_id, define_field: false
  end

  def form_changeset(step, params \\ %{}, assoc \\ %{}) do
    step
    |> cast(params, [
      :id,
      :storage_status,
      :record_status,
      :name,
      :description,
      :team_id
    ])
    |> Helpers.validate_assoc(:team, assoc.team)
  end
end
