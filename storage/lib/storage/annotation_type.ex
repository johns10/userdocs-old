defmodule Storage.AnnotationType do
  use Ecto.Schema

  schema "annotation_type" do

    field :script, :string
    field :params, { :array, :string }

    has_many :annotation, Storage.Annotation
  end
end
