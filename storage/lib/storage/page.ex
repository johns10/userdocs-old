defmodule Storage.Page do
  use Ecto.Schema
  import Ecto.Changeset
  alias Storage.Helpers

  schema "page" do
    field :storage_status,  :string,  virtual: true

    field :url, :string
    field :record_status,   :string

    field :version_id,      :integer

    belongs_to  :version, Storage.Version, foreign_key: :version_id, references: :id, define_field: false

  end

  def form_changeset(page, params \\ %{}, assoc \\ %{}) do
    #IO.puts("Applying Project Changeset")
    page
    |> cast(params, [ :storage_status, :record_status, :url, :id, :version_id ])
    |> Helpers.validate_assoc(:version, assoc.version)
    |> validate_required([ :url ])
  end
end
