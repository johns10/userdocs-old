defmodule State.State do
  defstruct(
    step_type: %{
      navigate: %{
        type: :step_type,
        attributes: %{
          args: [:strategy, :selector]

        }
      },
      wait: %{
        type: :step_type,
        attributes: %{
          args: [:strategy, :selector]
        }
      },
      click: %{
        type: :step_type,
        attributes: %{
          args: [:strategy, :selector]
        }
      },
      fill_field: %{
        type: :step_type,
        attributes: %{
          args: [:strategy, :selector, :text]
        }
      },
      javascript: %{
        type: :step_type,
        attributes: %{
          args: [:procedure, :types, :text]
        }
      }
    },
    page: %{
      default: %{
        type: :page,
        attributes: %{
          url: "www.google.com"
        },
        relationships: %{
          procedure: :default_procedure
        }
      }
    },
    procedure: %{
      default_procedure: %{
        type: :procedure,
        attributes: %{
          name: "Procedure Name"
        },
        relationships: %{
          step: [:default],
          page: [:default]
        }
      },
      default_procedure_2: %{
        type: :procedure,
        attributes: %{
          name: "Procedure Name 2"
        },
        relationships: %{
          step: [:default, :default2],
          page: [:default]
        }
      }
    },
    step: %{
      default: %{
        type: :step,
        attributes: %{
          strategy: :xpath,
          args: [
            selector:
              ~s|/html//form[@id='tsf']//div[@class='A8SBwf']/div[@class='FPdoLc VlcLAe']/center/input[@name='btnK']|
          ]
        },
        relationships: %{
          step_type: :wait
        }
      },
      default2: %{
        type: :step,
        attributes: %{
          strategy: :xpath,
          args: [
            selector:
              ~s|/html//form[@id='tsf']//div[@class='A8SBwf']/div[@class='FPdoLc VlcLAe']/center/input[@name='btnK']|
          ]
        },
        relationships: %{
          step_type: :wait
        }
      }
    }
  )

  def new_state() do
    %State.State{}
  end

  def create(state, type, key, value) do
    #IO.puts("Creating Object")
    state
    |> Map.pop(type)
    |> create_object(key, value)
    |> put_objects_on_state(type)
    |> get(type, [ key ], [])
  end

  def get(state, type, keys, includes) do
    #IO.puts("Getting Data of type #{type} with keys:")
    #IO.inspect(keys)
    get_data_type({state, type, keys, includes})
    |> get_by_ids()
    |> get_relationships
  end

  def update(state, type, key, value) do
    #IO.puts("Updating #{type} -> #{key}")
    state
    |> Map.pop(type)
    |> update_object(key, value)
    |> put_objects_on_state(type)
    |> get(type, [ key ], [])
  end

  def delete(state, type, key) do
    #IO.puts("Deleting #{type} -> key")
    state
    |> Map.pop(type)
    |> delete_object(key)
    |> put_objects_on_state(type)
  end

  ######################### Private functions #################################

  def put_objects_on_state({ state, objects }, type) do
    Map.put(state, type, objects)
  end

  def delete_object({ objects, state }, key) do
    { state, Map.delete(objects, key) }
  end

  def update_object({ objects, state }, key, value) do
    { state, Map.update!(objects, key, fn (_x) -> value end) }
  end

  def create_object({ objects, state }, key, value) do
    { state, Map.put(objects, key, value) }
  end

  def get_data_type({state, type, keys, includes}) do
    {:ok, result} = Map.fetch(state, type)
    { state, result, keys, includes }
  end

  def get_by_ids({state, data, [], includes}) do
    #IO.puts("Passing get by ids")
    { state, data, includes }
  end

  def get_by_ids({state, data, keys, includes}) do
    #IO.puts("Getting by ID's")
    result = Map.take(data, keys)
    { state, result, includes }
  end

  def get_relationships({ state, data, [] }) do
    { state, data }
  end
  def get_relationships({ state, data, includes }) do
    #IO.puts("Getting Relationships")
    {
      state,
      Enum.map(
        data,
        fn {key, object} ->
          { key, %{
            attributes: object.attributes,
            type: object.type,
            relationships: Enum.map(
              object.relationships,
              fn {type, related_ids} ->
                updated_relationship = get_relationship_data(state, type, related_ids, Enum.member?(includes, type))
                {type, updated_relationship}
              end
            )
          }}
        end
      )
    }
  end

  def get_relationship_data(state, type, related_ids, true) do
    #IO.puts("Getting relationship data")
    { _state, result } = get(state, type, related_ids, [])
    result
  end

  def get_relationship_data(_state, _type, related_ids, false) do
    related_ids
  end

end

  '''
  def get_includes({ state, data, [] }) do
    { state, data }
  end
  def get_includes({ state, [ object | objects ], includes }) do
    IO.puts("Getting Includes: ")
    #IO.inspect(includes)
    #IO.inspect(data)
    { state, object, includes }
    |> get_object_relationships()
    |> update_object()
  end

  def get_object_relationships({ state, { key, object }, includes }) do
    IO.puts("Getting object includes")
    result = Map.take(object.relationships, includes)
    #|> IO.inspect()
    |> Enum.map(
      fn { type, keys } ->
        #IO.puts("relationship type")
        #IO.inspect(type)
        #IO.inspect(keys)
        { state, result } = get(state, type, keys, [])
        { type, result}
      end
    )
    { state, object, Enum.into(result, %{}) }
  end

  def update_object({ state, object, data_to_include }) do
    IO.puts("Updating Object")
    #IO.inspect(object)
    #IO.inspect(includes)
    Map.update!(
      object,
      :relationships,
      fn (object_relationships) ->
        update_relationships({ state, object, object_relationships, data_to_include })
      end
    )
  end

  def update_relationships({ state, object, relationships, data_to_include}) do
    IO.puts("Updating Relationships")
    #IO.inspect(relationships)
    #IO.inspect(includes)
    Enum.map(
      relationships,
      fn (relationship) ->
        #IO.inspect(relationship)
        update_relationship({ state, object, relationship, data_to_include})
      end
    )
  end

  def update_relationship({ state, object, { type, related_ids }, data_to_include }) do
    IO.puts("Updating relationship")
    Enum.map(
      related_ids,
      fn (id) ->
        IO.puts(id)
        #IO.puts("object")
        #IO.inspect(object)
        IO.puts("data to include")
        IO.inspect(data_to_include[type][id])
        Map.update!(
          object,
          :relationships,
          fn (x) ->
            IO.inspect(x)
          end
        )
        { id, data_to_include[type][id] }
      end
    )
  end

  def get_relationship_data(state, { key, object }, includes) do
    IO.puts("Getting Relationship Data")
    #IO.inspect(object.relationships)
    #IO.inspect(includes)
    get = Map.take(object.relationships, includes)
    #IO.inspect(get)
    Enum.map(
      get,
      fn { type, keys } ->
        #IO.inspect(type)
        { state, result } = get(state, type, keys, [])
        Map.update!(
          object,
          :relationships,
          fn (relationship) ->
            #IO.inspect(type)
            #IO.inspect(relationship)
            IO.puts("In the final update")
            Map.update!(
              relationship,
              type,
              fn (filter) ->
                #IO.inspect(filter)
                #IO.inspect(result)
                Map.take(result, filter)
                #|> IO.inspect()
              end
            )
            |> IO.inspect()
          end
        )
        #IO.inspect(result)
      end
    )
  end


  def get_all_includes({ state, data, includes }) do
    IO.puts("Getting All Includes")
    IO.inspect(data)
    result = Enum.map(
      data,
      fn { key, object } ->
        IO.inspect(key)
        IO.inspect(object)
        { key, Map.take(object.relationships, includes) }
      end
    )
    #IO.inspect(result)
    { state, result, includes }
  end

  def get_all_related_data({ state, data, [] }) do
    IO.puts("Passing get all related data")
    #IO.inspect(data)
    { state, data, %{}, [] }
  end
  def get_all_related_data({ state, data, includes }) do
    IO.puts("Getting Included Data")
    #IO.inspect(data)
    related = Enum.map(
      data,
      fn{ key, object } ->
        IO.inspect(key)
        #IO.inspect(object)
        get_related_data({ state, object, includes })
        #|> IO.inspect()
      end
    )
    #IO.inspect(related)
    { state, data, related, includes }
  end

  def get_related_data({ state, object, [] }) do
    IO.puts("Passing Get Related Data")
    { state, %{} }
  end
  def get_related_data({ state, object, includes }) do
    IO.puts("Getting Related Data")
    #IO.inspect(object)
    #IO.inspect(includes)
    result = Enum.map(
      object.relationships,
      fn { type, related } ->
        #IO.inspect(type)
        #IO.inspect(related)
        #IO.inspect(result)
        hydrated_relationships = Map.update!(
          object.relationships,
          type,
          fn(keys) ->
            #IO.inspect(type)
            #IO.inspect(keys)
            { state, result } = get(state, type, keys, [])
            IO.inspect(result)
            result
          end
        )
        |> IO.inspect
      end
    )
    #IO.inspect(result)
    { state, result }
  end

  def attach_included({ state, data, related, includes }) do
    IO.puts("Attaching includes")
    #IO.inspect(data)
    #IO.inspect(related)
    #IO.inspect(includes)
    { state, data }
  end
  '''
