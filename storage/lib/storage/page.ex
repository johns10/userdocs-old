defmodule Storage.Page do
  use Ecto.Schema

  schema "page" do
    field :type, :string
    field :url, :string
    has_many :annotation, Storage.Annotation
  end
end
