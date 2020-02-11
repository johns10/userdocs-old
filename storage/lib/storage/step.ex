defmodule Storage.Step do
  use Ecto.Schema

  import Ecto.Changeset

  alias Storage.Helpers

  schema "step" do
    field :changeset,       :map,     virtual: true
    field :storage_status,  :string,  virtual: true

    field :order,           :integer
    #field :args,            :map

    field :version_id,      :integer
    field :annotation_id,   :integer
    field :step_type_id,    :integer
    field :page_id,         :integer
    field :record_status,   :string

    belongs_to :version,    Storage.Version,    foreign_key: :id, references: :version_id, define_field: false
    belongs_to :annotation, Storage.Annotation, foreign_key: :id, references: :annotation_id, define_field: false
    belongs_to :step_type,  Storage.StepType,   foreign_key: :id, references: :step_type_id, define_field: false
    belongs_to :page,       Storage.Page,       foreign_key: :id, references: :page_id, define_field: false

    embeds_many :args,      Storage.Arg
  end

  def form_changeset(step, params \\ %{}, assoc \\ %{}) do
    step
    |> cast(params, [ :id, :storage_status, :record_status, :order, :version_id, :annotation_id, :step_type_id, :page_id ])
    |> cast_embed(:args)
    |> Helpers.validate_assoc(:version, assoc.version)
    |> Helpers.validate_assoc(:annotation, assoc.annotation)
    |> Helpers.validate_assoc(:step_type, assoc.step_type)
    |> Helpers.validate_assoc(:page, assoc.page)
    |> validate_required([:order])
  end
end
