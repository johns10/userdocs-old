defmodule Storage.Arg do
  use Ecto.Schema

  import Ecto.Changeset

  alias Storage.Helpers

  embedded_schema do
    field :key,     :string
    field :value,   :string
  end

  def changeset(step, params \\ %{}, assoc \\ %{}) do
    step
    |> cast(params, [ :key, :value ])
  end
end
