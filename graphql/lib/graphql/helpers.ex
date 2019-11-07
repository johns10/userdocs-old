defmodule Graphql.Helpers do

  def create(args, type) do
    {
      :ok,
      result = State.create(
        type,
        String.to_atom(args.id),
        graphql_to_state(args, type)
      )
      |> Enum.at(0)
      |> state_to_graphql()
    }
  end

  def get( %{ ids: ids }, type) do
    #IO.inspect(args)
    result = State.get(type, string_list_to_tuple(ids), [])
    |> IO.inspect()
    |> Enum.map(&state_to_graphql(&1))
    { :ok, result }
  end

  def get( %{ id: id }, type) do
    IO.inspect(id)
    result = State.get(type, [String.to_atom(id)], [])
    |> IO.inspect
    |> Enum.at(0)
    |> state_to_graphql()
    { :ok, result }
  end

  def get(args, type) do
    IO.inspect(args)
    { :ok, %{ id: "Test"} }
  end


  def update(args, type) do
    {
      :ok,
      result = State.update(
        String.to_atom(args.id),
        graphql_to_state(args, type)
      )
      |> Enum.at(0)
      |> state_to_graphql
    }
  end

  def delete(args, type) do
    {
      :ok,
      %{ id: State.delete(
        type,
        String.to_atom(args.id)
      )}
    }
  end

  def state_to_graphql({ key, object }) do
    Enum.reduce(
      object,
      %{ id: key},
      fn({ key, value }, acc)->
        Map.merge(acc, %{ key => value })
      end
    )
  end

  def graphql_to_state(args, type) do
    Map.delete(args, :id)
  end

  def string_list_to_tuple(strings) do
    Enum.map(strings,
      &String.to_atom(&1)
    )
  end

  def atoms_to_strings(atoms) do
    Enum.map(atoms,
      &Atom.to_string(&1)
    )
  end

end
