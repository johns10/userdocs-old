defmodule StateHandlers.Helpers do

  ################### Generic #########################
  def put_objects_on_state({ state, objects }, type) do
    Map.put(state, type, objects)
  end

  ################### Create ##########################
  def create_object({ objects, state }, key, value) do
    { state, Map.put(objects, key, value) }
  end

  ################### Get #############################
  def get_data_type({ state }, type ) do
    {:ok, result} = Map.fetch(state, type)
    { state, result }
  end

  def get_by_ids({ state, data }, [] ) do
    #IO.puts("Passing get by ids")
    { state, data }
  end
  def get_by_ids({ state, data }, [ id | [] ] ) do
    { state, Map.take(data, [ id ])}
  end
  def get_by_ids({ state, data }, ids = [ _id | _id_list ] ) do
    #IO.puts("Getting by ID's")
    { state, Map.take(data, ids) }
  end
  def get_by_ids({ state, data }, id ) do
    { state, Map.take(data, [ id ])}
  end

  ##################### Update #########################
  #TODO: This creates non-existent keys.  Should raise Keyerror
  def update_object({ objects, state }, key, value) do
    #IO.puts("Updating Object")
    result = Map.update!(objects, key, fn (_x) -> value end)
    { state, result }
  end

  ##################### Delete #########################
  def delete_object({ objects, state }, key) do
    { state, Map.delete(objects, key) }
  end

end
