defmodule Storage.StepType do
  use Ecto.Schema

  schema "step_type" do
    field :name,  :string
    field :order, :integer
    field :args,  { :array, :string }
  end
end
