defmodule StateHandlers.Handle do

  alias StateHandlers.Helpers

  def get(state, type, ids \\ []) do
    #IO.puts("Getting Data of type #{type} with ids:")
    Helpers.get_data_type({ state }, type)
    |> Helpers.get_by_ids(ids)
  end

  @doc """
  Takes a list of objects, and a type of relationship.  Makes a list of the
  related ids, by the given type, and queries the state for the ID's in that
  list.
  Used to get all the objects related in a single shot.
  """
  def get_related(state, from_type, from_ids, to_type) do
    { state, to_data } = get(state, to_type)
    ids = Enum.reduce(
      to_data,
      [],
      fn { id, object }, ids ->
        try do
          true = Enum.member?(from_ids, object[from_type])
          [ id | ids ]
        rescue
          MatchError -> ids
        end
      end
    )
    |> List.flatten()
    |> Enum.uniq()
    get(state, to_type, ids)
  end

  def create(state, type, id, object) do
    #IO.puts("Creating Object")
    state
    |> Map.pop(type)
    |> Helpers.create_object(id, object)
    |> Helpers.put_objects_on_state(type)
    |> get(type, [ id ])
  end

  def update(state, type, id, object) do
    #IO.puts("Updating #{type} -> #{id}")
    state
    |> Map.pop(type)
    |> Helpers.update_object(id, object)
    |> Helpers.put_objects_on_state(type)
    |> get(type, [ id ])
  end

  def delete(state, type, id) do
    #IO.puts("Deleting #{type} -> id")
    state
    |> Map.pop(type)
    |> Helpers.delete_object(id)
    |> Helpers.put_objects_on_state(type)

  end

end
