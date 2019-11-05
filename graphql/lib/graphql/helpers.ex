defmodule Graphql.Helpers do

  def create(state, args, type) do
    {
      :ok,
      result = State.create(
        state,
        type,
        String.to_atom(args.id),
        graphql_to_state(args, type)
      )
      |> Enum.at(0)
      |> state_to_graphql()
      |> IO.inspect()
    }
  end

  def get(state, args, type) do
    result = State.get(state, type, string_list_to_tuple(args.ids), [])
    |> Enum.map(&state_to_graphql(&1))
    { :ok, result }
  end

  def state_to_graphql({ key, object }) do
    Enum.reduce(
      object.attributes,
      %{ id: key},
      fn({ key, value }, acc)->
        Map.merge(acc, %{ key => value })
      end
    )
  end

  def graphql_to_state(args, type) do
    %{
      attributes: Map.delete(args, :id)
    }
  end



  def map_fields(objects) do
    Enum.map(objects,
      fn { key, value } ->
        fields = Enum.reduce(
        value.attributes,
        %{ id: key},
          fn { key, value }, acc ->
            Map.merge(acc, %{ key => value })
          end
        )
      end
    )
  end

  def map_object_fields({ key, object }) do
    %{
      attributes: Enum.reduce(
        object,
        %{ },
        fn{ key, value }, acc ->
          Map.merge(acc, %{ key => value })
        end
      )
    }
  end

  def string_list_to_tuple(strings) do
    Enum.map(strings,
      &String.to_atom(&1)
    )
  end

end
