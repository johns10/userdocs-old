defmodule State.Helpers do

  '''
  def include(object, [ relationship_type | relationship_types ]) do
    { object, relationship_type }
    |> get_relationship_module()
    |> get_relationship_data()
    #|> get_related
    #|> retreive_related_data
  end

  def get_relationship_module({ object, relationship_type }) do
    module = relationship_type
    |> to_string
    |> Macro.camelize()
    |> (fn (x) -> "Elixir.State." <> x end).()
    |> String.replace(~r/\.Country/, "")
    |> String.to_atom
    { object, relationship_type, module }
  end

  def get_relationship_data({ object, relationship_type, module }) do
    keys = object.relationships[relationship_type]
    apply(module, :get, keys)

  end

  def get_relationship({ object, related }, relationship_type) do
    related = Map.put(related, relationship_type, object.relationships[relationship_type])
    { object, related }
  end

  def get_related(thing) do

  end
'''
  def retreive_related_data({ indexes, related }) do
    Enum.map(indexes, fn x -> related[x] end)
  end

end
