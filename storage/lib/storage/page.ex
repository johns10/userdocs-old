defmodule Storage.Page do
  use Ecto.Schema

  schema "page" do
    field :url, :string
    belongs_to :version, Storage.Version
  end
end
