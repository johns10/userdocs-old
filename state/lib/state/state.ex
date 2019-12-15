defmodule State.State do

  defstruct(
    project: %{
      funnel_cloud: %{
        title: "FunnelCloud Staging",
        base_url: "https://staging.app.funnelcloud.io",
        type: :web
      }
    },
    page: %{
      default: %{
        type: :page,
        url: "www.google.com",
        procedure: :default_procedure,
        project: :default
        },
      default2: %{
        type: :page,
        url: "www.msn.com",
        procedure: :default_procedure_2,
        project: :default
      },
      at_a_glance: %{
        type: :page,
        url: "https://staging.app.funnelcloud.io/#/plant/All/overview/at-a-glance",
        procedure: :funnel_cloud_login_procedure,
        project: :funnel_cloud
      },
      machine: %{
        type: :page,
        url: "https://staging.app.funnelcloud.io/#/machines/1",
        procedure: :funnel_cloud_login_procedure,
        project: :funnel_cloud
      }
    },
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
    procedure: %{
      default_procedure: %{
        type: :procedure,
        name: "Procedure Name"
      },
      default_procedure_2: %{
        type: :procedure,
        name: "Procedure Name 2"
      },
      funnel_cloud_login_procedure: %{
        type: :procedure,
        name: "FunnelCloud Login Procedure"
      }
    },
    step: %{
      one: %{
        type: :step,
        args: %{
          url: "www.google.com",
        },
        step_type: :navigate,
        strategy:     :text,
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
      },
      six: %{
        order: 1,
        type: :step,
        strategy: :text,
        args: %{
          url: "https://staging.app.funnelcloud.io/#/setup",
        },
        step_type: :navigate,
        project: :funnel_cloud
      },
      seven: %{
        order: 2,
        type:         :step,
        step_type:    :wait,
        strategy:     :xpath,
        args: %{
          selector:   ~s|/html/body/div[@class='ember-view']/div[9]/div//form//button[1]|
        },
        project: :funnel_cloud
      },
      eight: %{
        order: 3,
        type:         :step,
        step_type:    :click,
        strategy:     :xpath,
        args: %{
          selector:   ~s|/html/body/div[@class='ember-view']/div[9]/div//form//button[contains(.,'Next')]|
        },
        project: :funnel_cloud
      },
      nine: %{
        order: 4,
        type:         :step,
        step_type:    :wait,
        strategy:     :xpath,
        args: %{
          selector:   ~s|/html/body/div[@class='ember-view']/div[9]/div//form//div[@class='modal-container']/div/div[@class='content']/div/div[1]/div[3]|
        },
        project: :funnel_cloud
      },
      ten: %{
        order: 5,
        type:         :step,
        step_type:    :click,
        strategy:     :xpath,
        args: %{
          selector:   ~s|/html/body/div[@class='ember-view']/div[9]/div//form//div[@class='modal-container']/div/div[@class='content']/div/div[1]/div[3]|
        },
        project: :funnel_cloud
      },
      eleven: %{
        order: 6,
        type:         :step,
        step_type:    :wait,
        strategy:     :xpath,
        args: %{
          selector:   ~s|/html/body/div[@class='ember-view']/div[9]/div//form//button[contains(.,'Next Page')]|
        },
        project: :funnel_cloud
      },
      twelve: %{
        order: 7,
        type:         :step,
        step_type:    :click,
        strategy:     :xpath,
        args: %{
          selector:   ~s|/html/body/div[@class='ember-view']/div[9]/div//form//button[contains(.,'Next Page')]|
        },
        project: :funnel_cloud
      },
      thirteen: %{
        order: 8,
        type:         :step,
        step_type:    :wait,
        strategy:     :xpath,
        args: %{
          selector:   ~s|/html/body/div[@class='ember-view']/div[9]/div//form//button[contains(.,'Save')]|
        },
        project: :funnel_cloud
      },
      fourteen: %{
        order: 9,
        type:         :step,
        step_type:    :click,
        strategy:     :xpath,
        args: %{
          selector:   ~s|/html/body/div[@class='ember-view']/div[9]/div//form//button[contains(.,'Save')]|
        },
        project: :funnel_cloud
      },
      fifteen: %{
        order: 10,
        type:         :step,
        strategy:     :text,
        step_type:    :navigate,
        args: %{
          url:        "https://staging.app.funnelcloud.io/#/login"
        },
        project: :funnel_cloud
      },
      sixteen: %{
        order: 11,
        type:         :step,
        step_type:    :wait,
        strategy:     :xpath,
        args: %{
          selector:   ~s|/html/body/div[@class='ember-view']/div[9]/div//form//input[@placeholder='Username']|
        },
        project: :funnel_cloud
      },
      seventeen: %{
        order: 12,
        type:         :step,
        step_type:    :fill_field,
        strategy:     :xpath,
        args: %{
          selector:   ~s|/html/body/div[@class='ember-view']/div[9]/div//form//input[@placeholder='Username']|,
          text:       "admin@funnelcloud.io"
        },
        project: :funnel_cloud
      },
      eighteen: %{
        order: 13,
        type:         :step,
        step_type:    :fill_field,
        strategy:     :xpath,
        args: %{
          selector:   ~s|/html/body/div[@class='ember-view']/div[9]/div//form//input[@placeholder='Password']|,
          text:       "FirstTimer"
        },
        project: :funnel_cloud
      },
      nineteen: %{
        order: 14,
        type:         :step,
        step_type:    :click,
        strategy:     :xpath,
        args: %{
          selector:   ~s|/html/body/div[@class='ember-view']/div[9]//form//button|
        },
        project: :funnel_cloud
      },
      twenty: %{
        page:         :at_a_glance,
        order:        1,
        type:         :step,
        step_type:    :navigate,
        args: %{
          url:   "https://varvy.com/pagespeed/wicked-fast.html"
        }
      },
      twenty_one: %{
        page:         :at_a_glance,
        order:        2,
        type:         :step,
        step_type:    :wait,
        args: %{
          strategy:   :xpath,
          selector:   ~s|//div[@id='menu']/ul//a[@href='/']|
        },
      },
      twenty_two: %{
        page:         :at_a_glance,
        order:        3,
        type:         :step,
        step_type:    :javascript,
        args: %{
          script_type: :badge,
          strategy: :xpath,
          selector: ~s|//div[@id='menu']/ul//a[@href='/']|,
          size: 15,
          label: "1",
          color: 'red'
        }
      }
    },
    script: %{
      outline: %{
        prototype: """
        function outline(selector, color, thickness) {
          var element = document.evaluate(selector, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
          element.style.outline = color.concat(' solid ', thickness, 'px';
        }
        outline(arguments[0], arguments[1], arguments[2])
        """,
        args: [ :selector, :color, :thickness],
      },

      badge: %{
        prototype: """
        function badge(selector, size, label, color) {
          console.log(selector)
          console.log(size)
          console.log(label)
          console.log(color)
          var element = document.evaluate(selector, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
          var wrapper = document.createElement('div');
          var badge = document.createElement('span');
          var textnode = document.createTextNode(label);
          element.appendChild(wrapper);
          badge.appendChild(textnode);
          wrapper.appendChild(badge);
          element.style.position = 'relative';
          wrapper.style.display = '';
          wrapper.style.justifyContent = 'center';
          wrapper.style.alignItems = 'center';
          wrapper.style.minHeight = '';
          wrapper.style.position = 'absolute';
          wrapper.style.top = (-1 * size).toString(10) + 'px';
          wrapper.style.right = (-1 * size).toString(10) + 'px';
          badge.style.display = 'inline-block';
          badge.style.minWidth = '16px';
          badge.style.padding = (0.5 * size).toString(10) + 'px ' + (0.5 * size).toString(10) + 'px';
          badge.style.borderRadius = '50%';
          badge.style.fontSize = '25px';
          badge.style.textAlign = 'center';
          badge.style.background = color;
          badge.style.color = 'white';
        }
        badge(arguments[0], arguments[1], arguments[2], arguments[3])
        """,
        args: [ :selector, :size, :label, :color ]
      }
    },
    selector_type: %{
      xpath: %{
        prototype: ~s|var element = document.evaluate('<%= selector %>', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;|,
        args: [ 'selector' ]
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
      },
      production_line_outline: %{
        title: "Production Line",
        annotation_type: :outline,
        strategy: :xpath,
        selector: ~s|/html/body/div[@class='ember-view']/div[9]/div/div//table/tbody/tr/td[1]|,
        label: "1",
        description: "This is the production line.",
        type: :annotation,
        page: :at_a_glance,
        args: %{
          strategy: :xpath,
          selector: ~s|/html/body/div[@class='ember-view']/div[9]/div/div//table/tbody/tr/td[1]|,
          color: 'red',
          thickness: 2
        }
      },
      production_line_badge: %{
        title: "Production Line",
        annotation_type: :badge,
        strategy: :xpath,
        selector: ~s|/html/body/div[@class='ember-view']/div[9]/div/div//table/tbody/tr/td[1]|,
        label: "1",
        description: "This is the production line.",
        type: :annotation,
        page: :at_a_glance,
        args: %{
          strategy: :xpath,
          selector: ~s|/html/body/div[@class='ember-view']/div[9]/div/div//table/tbody/tr/td[1]|,
          size: 15,
          label: "1",
          color: 'red'
        }
      },
      current_process_outline: %{
        title: "Current Process",
        annotation_type: :outline,
        strategy: :xpath,
        selector: ~s|/html/body/div[@class='ember-view']/div[9]/div/div//table/tbody/tr/td[2]|,
        label: "1",
        description: "This is the production line.",
        type: :annotation,
        page: :at_a_glance,
        args: %{
          strategy: :xpath,
          selector: ~s|/html/body/div[@class='ember-view']/div[9]/div/div//table/tbody/tr/td[2]|,
          color: 'red',
          thickness: 2
        }
      },
      current_process_badge: %{
        title: "Current Process",
        annotation_type: :badge,
        strategy: :xpath,
        selector: ~s|/html/body/div[@class='ember-view']/div[9]/div/div//table/tbody/tr/td[2]|,
        label: "1",
        description: "This is the production line.",
        type: :annotation,
        page: :at_a_glance,
        args: %{
          strategy: :xpath,
          selector: ~s|/html/body/div[@class='ember-view']/div[9]/div/div//table/tbody/tr/td[2]|,
          size: 15,
          label: "1",
          color: 'red'
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
        end
      end
    )
    |> List.flatten()
    |> Enum.uniq()
    get(state, to_type, ids)
  end

  ######################### Private functions #################################

  def live_broadcast({ state, data }, type) do
    #IO.puts("Broadcasting")
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
    { _state, related } = get(state, related_type)
    Enum.reduce(
      related,
      %{},
      fn { id, object }, objects ->
        #IO.inspect("Processing related object #{object.type}: #{id} to #{object[object_from.type]}")
        try do
          ^id_from = object[object_from.type]
          Map.put(objects, id, object)
        rescue
          MatchError -> objects
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
