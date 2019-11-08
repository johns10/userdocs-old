defmodule State.State do
  defstruct(
    step_type: %{
      navigate: %{
        type: :step_type,
        args: [:strategy, :selector]
      },
      wait: %{
        type: :step_type,
        args: [:strategy, :selector]
      },
      click: %{
        type: :step_type,
        args: [:strategy, :selector]
      },
      fill_field: %{
        type: :step_type,
        args: [:strategy, :selector, :text]
      },
      javascript: %{
        type: :step_type,
        args: [:procedure, :types, :text]
      }
    },
    page: %{
      default: %{
        type: :page,
        url: "www.google.com",
        procedure: :default_procedure,
        annotations: [ :default1, :default2 ]
        },
      default2: %{
        type: :page,
        url: "www.msn.com",
        procedure: :default_procedure_2,
        annotations: [ :default1, :default2 ]
      }
    },
    procedure: %{
      default_procedure: %{
        type: :procedure,
        name: "Procedure Name",
        steps: [:default]
      },
      default_procedure_2: %{
        type: :procedure,
        name: "Procedure Name 2",
        steps: [:default, :default2],
      }
    },
    step: %{
      default: %{
        type: :step,
        strategy: :xpath,
        args: [
          selector:
            ~s|/html//form[@id='tsf']//div[@class='A8SBwf']/div[@class='FPdoLc VlcLAe']/center/input[@name='btnK']|
        ],
        step_type: :wait
      },
      default2: %{
        type: :step,
        strategy: :xpath,
        args: [
          selector:
            ~s|/html//form[@id='tsf']//div[@class='A8SBwf']/div[@class='FPdoLc VlcLAe']/center/input[@name='btnK']|
        ],
        step_type: :wait
      }
    },
    annotation_type: %{
      outline: %{
        script: ~s|element.style.outline = '#{color} solid #{thickness}px'|,
        params: [ 'color', 'thickness'],
      },

      outline: %{
        script: ~s|var size = #{size}; var label = #{label}; var color = '#{color}'; var wrapper = document.createElement('div'); var badge = document.createElement('span'); var textnode = document.createTextNode(label); element.appendChild(wrapper); badge.appendChild(textnode); wrapper.appendChild(badge); element.style.position = 'relative'; wrapper.style.display = ''; wrapper.style.justifyContent = 'center'; wrapper.style.alignItems = 'center'; wrapper.style.minHeight = ''; wrapper.style.position = 'absolute'; wrapper.style.top = (-1 * size).toString(10) + 'px'; wrapper.style.right = (-1 * size).toString(10) + 'px'; badge.style.display = 'inline-block'; badge.style.minWidth = '16px'; badge.style.padding = (0.5 * size).toString(10) + 'px ' + (0.5 * size).toString(10) + 'px'; badge.style.borderRadius = '50%'; badge.style.fontSize = '25px'; badge.style.textAlign = 'center'; badge.style.background = color; badge.style.color = 'white';|,
        params: [ 'size', 'radius', 'label' ]
      }
    },
    annotations: %{
      default1: %{
        types: [ :outline, :badge ],
        strategy: :xpath,
        selector: ~s|/html/body/div[@class='ember-view']/div[9]/div/div//table/tbody/tr/td[1]|,
        label: "1",
        description: "This is the description"
      },
      default2: %{
        types: [ :outline, :badge ],
        strategy: :xpath,
        selector: ~s|/html/body/div[@class='ember-view']/div[9]/div/div//table/tbody/tr/td[2]|,
        label: "2",
        description: "This is the description2"
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
    { state, data, includes } = get_data_type({state, type, keys, includes})
    |> get_by_ids()
    #|> get_relationships()
    { state, data }
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
    state = state
    |> Map.pop(type)
    |> delete_object(key)
    |> put_objects_on_state(type)
    { state, key }
  end

  ######################### Private functions #################################

  def put_objects_on_state({ state, objects }, type) do
    Map.put(state, type, objects)
  end

  def delete_object({ objects, state }, key) do
    { state, Map.delete(objects, key) }
  end

  #TODO: This creates non-existent keys.  Should raise Keyerror
  def update_object({ objects, state }, key, value) do
    IO.puts("Updating Object")
    result = Map.update!(objects, key, fn (_x) -> value end)
    { state, result }
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
    IO.puts("Getting by ID's")
    { state, Map.take(data, keys), includes }
  end
'''
Temporarily disabled because gql doesn't need
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
'''
end
