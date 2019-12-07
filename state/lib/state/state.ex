defmodule State.State do

  defstruct(
    step_type: %{
      navigate: %{
        type: :step_type,
        args: [:url]
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
        procedure: :default_procedure
        },
      default2: %{
        type: :page,
        url: "www.msn.com",
        procedure: :default_procedure_2
      }
    },
    procedure: %{
      default_procedure: %{
        type: :procedure,
        name: "Procedure Name"
      },
      default_procedure_2: %{
        type: :procedure,
        name: "Procedure Name 2"
      }
    },
    step: %{
      one: %{
        type: :step,
        strategy: :xpath,
        args: %{
          url: "www.google.com",
        },
        step_type: :navigate,
        page: :default
      },
      two: %{
        type: :step,
        strategy: :xpath,
        args: %{
          selector: ~s|/html//form[@id='tsf']//div[@class='A8SBwf']/div[@class='FPdoLc VlcLAe']/center/input[@name='btnK']|,
        },
        step_type: :wait,
        page: :default
      },
      three: %{
        type: :step,
        strategy: :xpath,
        args: %{
          url: "www.google.com",
        },
        step_type: :wait,
        page: :default2
      },
      four: %{
        type: :step,
        strategy: :xpath,
        args: %{
          selector: ~s|/html//form[@id='tsf']//div[@class='A8SBwf']/div[@class='FPdoLc VlcLAe']/center/input[@name='btnK']|,
        },
        step_type: :wait,
        page: :default2
      },
      five: %{
        type: :step,
        strategy: :xpath,
        args: %{
          selector: ~s|/html//form[@id='tsf']//div[@class='A8SBwf']/div[@class='FPdoLc VlcLAe']/center/input[@name='btnK']|,
        },
        step_type: :wait,
        page: :default3
      }
    },
    annotation_type: %{
      outline: %{
        script: ~s|element.style.outline = '{color} solid {thickness}px'|,
        params: [ 'color', 'thickness'],
      },

      badge: %{
        script: ~s|var size = {size}; var label = {label}; var color = '{color}'; var wrapper = document.createElement('div'); var badge = document.createElement('span'); var textnode = document.createTextNode(label); element.appendChild(wrapper); badge.appendChild(textnode); wrapper.appendChild(badge); element.style.position = 'relative'; wrapper.style.display = ''; wrapper.style.justifyContent = 'center'; wrapper.style.alignItems = 'center'; wrapper.style.minHeight = ''; wrapper.style.position = 'absolute'; wrapper.style.top = (-1 * size).toString(10) + 'px'; wrapper.style.right = (-1 * size).toString(10) + 'px'; badge.style.display = 'inline-block'; badge.style.minWidth = '16px'; badge.style.padding = (0.5 * size).toString(10) + 'px ' + (0.5 * size).toString(10) + 'px'; badge.style.borderRadius = '50%'; badge.style.fontSize = '25px'; badge.style.textAlign = 'center'; badge.style.background = color; badge.style.color = 'white';|,
        params: [ 'size', 'radius', 'label' ]
      }
    },
    annotation: %{
      default1: %{
        title: "Manufacturing Process",
        annotation_type: :outline,
        strategy: :xpath,
        selector: ~s|/html/body/div[@class='ember-view']/div[9]/div/div//table/tbody/tr/td[1]|,
        label: "1",
        description: "This is the description",
        type: :annotation,
        page: :default
      },
      default2: %{
        title: "Actual Cycles",
        annotation_type: :badge,
        strategy: :xpath,
        selector: ~s|/html/body/div[@class='ember-view']/div[9]/div/div//table/tbody/tr/td[2]|,
        label: "2",
        description: "This is the description2",
        type: :annotation,
        page: :default
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
    |> get(type, [ key ])
    |> live_broadcast(type)
  end

  def get(state, type, ids \\ []) do
    #IO.puts("Getting Data of type #{type} with keys:")
    #IO.inspect(ids)
    get_data_type({ state }, type)
    |> get_by_ids(ids)
    #|> get_relationships()
  end

  def update(state, type, key, value) do
    #IO.puts("Updating #{type} -> #{key}")
    state
    |> Map.pop(type)
    |> update_object(key, value)
    |> put_objects_on_state(type)
    |> get(type, [ key ])
  end

  def delete(state, type, key) do
    #IO.puts("Deleting #{type} -> key")
    state = state
    |> Map.pop(type)
    |> delete_object(key)
    |> put_objects_on_state(type)
    { state, key}
  end

  @doc """
  Takes a list of objects, and a type of relationship.  Makes a list of the
  related ids, by the given type, and queries the state for the ID's in that
  list.
  Used to get all the objects related in a single shot.
  """
  def get_all_related_data(state, from_type, from_ids, to_type) do
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
          ids
        end
      end
    )
    |> List.flatten()
    |> Enum.uniq()
    get(state, to_type, ids)
  end

  ######################### Private functions #################################

  def live_broadcast({ state, data }, type) do
    IO.puts("Broadcasting")
    IO.inspect(data)
    Phoenix.PubSub.broadcast(:live_state, Atom.to_string(type), { data })
    { state, data }
  end

  def put_objects_on_state({ state, objects }, type) do
    Map.put(state, type, objects)
  end

  def delete_object({ objects, state }, key) do
    { state, Map.delete(objects, key) }
  end

  #TODO: This creates non-existent keys.  Should raise Keyerror
  def update_object({ objects, state }, key, value) do
    #IO.puts("Updating Object")
    result = Map.update!(objects, key, fn (_x) -> value end)
    { state, result }
  end

  def create_object({ objects, state }, key, value) do
    { state, Map.put(objects, key, value) }
  end

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

  def get_reverse_relationship(state, { id_from, object_from }, related_type) do
    #IO.inspect("Getting reverse relationship from #{object_from.type}: #{id_from} to #{related_type}")
    { state, related } = get(state, related_type)
    Enum.reduce(
      related,
      %{},
      fn { id, object }, objects ->
        #IO.inspect("Processing related object #{object.type}: #{id} to #{object[object_from.type]}")
        try do
          ^id_from = object[object_from.type]
          objects = Map.put(objects, id, object)
        rescue
          MatchError -> "relationship not available"
          objects
        end
      end
    )
  end

  def get_forward_ids(state, { id_from, object_from }, related_type) do
    #IO.inspect("Getting forward id from #{object_from.type}: #{id_from} to #{related_type}")
    { _state, related } = get(state, related_type)
    Enum.reduce(
      related,
      Map.put(object_from, related_type, []),
      fn { id, object }, updated_object ->
        #IO.inspect("Processing related object from #{object[object_from.type]}: id_from to #{object.type}: #{id}")
        try do
          ^id_from = object[object_from.type]
          Map.put(updated_object, related_type, [ id | updated_object[related_type] ])
        rescue
          MatchError -> updated_object
          updated_object
        end
      end
    )
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
