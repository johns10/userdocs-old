defmodule Storage.Annotation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Storage.Helpers

  schema "annotation" do
    field :changeset,           :map,     virtual: true
    field :storage_status,      :string,  virtual: true
    field :order,               :integer, virtual: true

    field :name,                :string
    field :label,               :string
    field :description,         :string

    field :annotation_type_id,  :integer
    field :page_id,  :integer

    has_one     :annotation_type,  Storage.AnnotationType,  foreign_key: :id, references: :annotation_type_id
    has_many    :step,             Storage.Step
    belongs_to  :page,             Storage.Page,            foreign_key: :id, references: :page_id, define_field: false

  end

  def form_changeset(annotation, params \\ %{}, assoc \\ %{}) do
    #IO.puts("applying Changeset")
    annotation
    |> cast(params, [ :annotation_type_id, :name, :label, :description ])
    |> Helpers.validate_assoc(:annotation_type, assoc.annotation_type)
    |> validate_required([:annotation_type_id])
  end

end
