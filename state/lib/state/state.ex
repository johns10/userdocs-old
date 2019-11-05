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
      },
      default2: %{
        type: :page,
        attributes: %{
          url: "www.msn.com"
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
