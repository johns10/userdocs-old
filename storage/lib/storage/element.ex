defmodule Storage.Element do
  use Ecto.Schema

  import Ecto.Changeset

  alias Storage.Helpers

  schema "element" do
    field :storage_status,  :string,  virtual: true

    field :record_status,   :string
    field :name,            :string
    field :strategy,        :string
    field :selector,        :string
    field :page_id,         :integer

    belongs_to :page,       Storage.Page,       foreign_key: :id, references: :page_id, define_field: false
  end

  def form_changeset(step, params \\ %{}, assoc \\ %{}) do
    step
    |> cast(params, [
      :id,
      :storage_status,
      :record_status,
      :name,
      :strategy,
      :selector,
      :page_id
    ])
    |> Helpers.validate_assoc(:page, assoc.page)
  end
end
