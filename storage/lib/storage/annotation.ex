defmodule Storage.Annotation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Storage.Helpers

  schema "annotation" do
    field :storage_status,  :string,  virtual: true

    field :record_status,       :string
    field :name,                :string
    field :label,               :string
    field :description,         :string

    field :annotation_type_id,  :integer
    field :page_id,             :integer
    field :element_id,          :integer
    field :content_id,          :integer

    has_one     :annotation_type,  Storage.AnnotationType,  foreign_key: :id, references: :annotation_type_id
    has_one     :element,          Storage.Element,         foreign_key: :id, references: :element_id
    has_one     :content,          Storage.Content,         foreign_key: :id, references: :content_id
    belongs_to  :page,             Storage.Page,            foreign_key: :id, references: :page_id, define_field: false

  end

  def form_changeset(annotation, params \\ %{}, assoc \\ %{}) do
    #IO.puts("applying Changeset")
    annotation
    |> cast(params, [
      :id, :storage_status, :record_status,
      :name, :label, :description,
      :annotation_type_id,  :page_id, :element_id, :content_id
      ])
    |> Helpers.validate_assoc(:annotation_type, assoc.annotation_type)
    |> validate_required([:annotation_type_id])
  end

end
