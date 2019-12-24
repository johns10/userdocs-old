defmodule State.State do

  defstruct(
    project: %{
      funnel_cloud: %{
        title:    "FunnelCloud Staging",
        base_url: "https://staging.app.funnelcloud.io",
        type:     :web
      },
      test: %{
        title:    "Test Project",
        base_url: "http://webdriveruniversity.com/",
        type:     :web
      }
    },
    version: %{
      one: %{
        version: 1.0,
        project: :test
      }
    },
    page: %{
      default: %{
        type:       :page,
        url:        "www.google.com",
        procedure:  :default_procedure,
        project:    :default
        },
      default2: %{
        type:       :page,
        url:        "www.msn.com",
        procedure:  :default_procedure_2,
        project:    :default
      },
      at_a_glance: %{
        type:       :page,
        url:        "https://staging.app.funnelcloud.io/#/plant/All/overview/at-a-glance",
        procedure:  :funnel_cloud_login_procedure,
        project:    :funnel_cloud
      },
      machine: %{
        type:       :page,
        url:        "https://staging.app.funnelcloud.io/#/machines/1",
        procedure:  :funnel_cloud_login_procedure,
        project:    :funnel_cloud
      },
      test_page: %{
        type:       :page,
        url:        "https://varvy.com/pagespeed/wicked-fast.html",
        procedure:  :funnel_cloud_login_procedure,
        project:    :test
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
        type:       :step,
        order:      1,
        args: %{
          url:      "www.google.com",
        },
        step_type:  :navigate,
        strategy:   :text,
        page:       :default
      },
      two: %{
        type:       :step,
        order:      2,
        strategy:   :xpath,
        args: %{
          selector: ~s|/html//form[@id='tsf']//div[@class='A8SBwf']/div[@class='FPdoLc VlcLAe']/center/input[@name='btnK']|,
        },
        step_type:  :wait,
        page:       :default
      },
      three: %{
        type:       :step,
        order:      3,
        strategy:   :xpath,
        args: %{
          url:      "www.google.com",
        },
        step_type:  :wait,
        page:       :default2
      },
      four: %{
        type:       :step,
        order:      4,
        strategy:   :xpath,
        args: %{
          selector: ~s|/html//form[@id='tsf']//div[@class='A8SBwf']/div[@class='FPdoLc VlcLAe']/center/input[@name='btnK']|,
        },
        step_type:  :wait,
        page:       :default2
      },
      five: %{
        type:       :step,
        order:      5,
        strategy:   :xpath,
        args: %{
          selector: ~s|/html//form[@id='tsf']//div[@class='A8SBwf']/div[@class='FPdoLc VlcLAe']/center/input[@name='btnK']|,
        },
        step_type:  :wait,
        page:       :default3
      },
      six: %{
        order:      1,
        type:       :step,
        strategy:   :text,
        args: %{
          url:      "https://staging.app.funnelcloud.io/#/setup",
        },
        step_type:  :navigate,
        project:    :funnel_cloud
      },
      seven: %{
        order:      2,
        type:       :step,
        step_type:  :wait,
        args: %{
          selector:  ~s|/html/body/div[@class='ember-view']/div[9]/div//form//button[1]|,
          strategy:   :xpath
        },
        project:    :funnel_cloud
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
        annotation:     :production_line,
        order:          3,
        type:           :step,
        step_type:      :javascript,
        args: %{
          script_type:  :badge,
          strategy:     :xpath,
          selector:     ~s|//div[@id='menu']/ul//a[@href='/']|,
          size:         15,
          label:        "1",
          color:        "red"
        }
      },
      twenty_three: %{
        annotation:     :production_line,
        order:          4,
        type:           :step,
        step_type:      :javascript,
        args: %{
          script_type:  :outline,
          strategy:     :xpath,
          selector:     ~s|//div[@id='menu']/ul//a[@href='/']|,
          thickness:    3,
          color:        "red"
        }
      },
      twenty_four: %{
        page:           :at_a_glance,
        order:          5,
        type:           :step,
        step_type:      :page_screenshot,
        args: %{

        }
      },
      twenty_five: %{
        project:        :test,
        order:          1,
        type:           :step,
        step_type:      :navigate,
        args: %{
          url:   "http://webdriveruniversity.com/"
        }
      },
      twenty_six: %{
        project:      :test,
        order:        2,
        type:         :step,
        step_type:    :wait,
        args: %{
          strategy:   :xpath,
          selector:   ~s|/html//a[@id='to-do-list']//h1[.='TO DO LIST']|
        }
      },
      twenty_seven: %{
        project:      :test,
        order:        3,
        type:         :step,
        step_type:    :navigate,
        args: %{
          url:   "http://webdriveruniversity.com/To-Do-List/index.html"
        }
      },
      twenty_eight: %{
        project:      :test,
        order:        4,
        type:         :step,
        step_type:    :wait,
        args: %{
          strategy:   :xpath,
          selector:   ~s|//div[@id='container']/ul/li[1]|
        }
      },
      twenty_nine: %{
        page:         :test_page,
        order:        1,
        type:         :step,
        step_type:    :navigate,
        args: %{
          url:   "https://varvy.com/pagespeed/wicked-fast.html"
        }
      },
      thirty: %{
        page:         :test_page,
        order:        2,
        type:         :step,
        step_type:    :wait,
        args: %{
          strategy:   :xpath,
          selector:   ~s|//div[@id='menu']/ul//a[@href='/']|
        },
      },
      thirty_one: %{
        annotation:     :test_annotation,
        order:          3,
        type:           :step,
        step_type:      :javascript,
        args: %{
          script_type:  :badge,
          strategy:     :xpath,
          selector:     ~s|//div[@id='menu']/ul//a[@href='/']|,
          size:         15,
          label:        "1",
          color:        "red"
        }
      },
      thirty_two: %{
        annotation:     :test_annotation,
        order:          4,
        type:           :step,
        step_type:      :javascript,
        args: %{
          script_type:  :outline,
          strategy:     :xpath,
          selector:     ~s|//div[@id='menu']/ul//a[@href='/']|,
          thickness:    3,
          color:        "red"
        }
      },
      thirty_three: %{
        annotation:     :test_annotation_2,
        order:          5,
        type:           :step,
        step_type:      :javascript,
        args: %{
          script_type:  :badge,
          strategy:     :xpath,
          selector:     ~s|//div[@id='menu']/ul//a[@href='/pagespeed/']|,
          size:         15,
          label:        "1",
          color:        "red"
        }
      },
      thirty_four: %{
        annotation:     :test_annotation_2,
        order:          6,
        type:           :step,
        step_type:      :javascript,
        args: %{
          script_type:  :outline,
          strategy:     :xpath,
          selector:     ~s|//div[@id='menu']/ul//a[@href='/pagespeed/']|,
          thickness:    3,
          color:        "red"
        }
      },
      thirty_five: %{
        page:           :test_page,
        order:          7,
        type:           :step,
        step_type:      :page_screenshot,
        args: %{

        }
      },

    },
    script: %{
      outline: %{
        prototype: """
        function outline(selector, color, thickness) {
          var element = document.evaluate(selector, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
          element.style.outline = color.concat(' solid ', thickness, 'px');
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
      },
      page_dimensions: %{
        prototype: """
        return {
          height: Math.max(
            document.body.scrollHeight,
            document.body.offsetHeight,
            document.documentElement.clientHeight,
            document.documentElement.scrollHeight,
            document.documentElement.offsetHeight
          ),
          width: Math.max(
            document.body.scrollWidth,
            document.body.offsetWidth,
            document.documentElement.clientWidth,
            document.documentElement.scrollWidth,
            document.documentElement.offsetWidth
          )
        }
        """
      }
    },
    selector_type: %{
      xpath: %{
        prototype: ~s|var element = document.evaluate('<%= selector %>', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;|,
        args: [ 'selector' ]
      }
    },
    annotation_type: %{
      outline: %{

      },
      badge: %{

      }
    },
    annotation: %{
      production_line: %{
        type: :annotation,
        title: "Production Line",
        annotation_type: :outline,
        label: "1",
        description: "This is the production line.",
        page: :at_a_glance,
      },
      current_process_outline: %{
        type: :annotation,
        title: "Current Process",
        annotation_type: :outline,
        label: "1",
        description: "This is the current running process.",
        page: :at_a_glance,
      },
      test_annotation: %{
        type: :annotation,
        title: "Google Guidelines",
        annotation_type: :outline,
        label: "1",
        description: "This is the google guidelines.",
        page: :test_page,
      },
      test_annotation_2: %{
        type: :annotation,
        title: "Page Speed",
        annotation_type: :outline,
        label: "1",
        description: "This is the page speed.",
        page: :test_page,
      }
    },
    job: %{
    },
    task: %{
    }
  )

  def new_state() do
    %State.State{}
  end

  def create(state, type, key, object) do
    StateHandlers.create(state, type, key, object)
    |> live_broadcast(:create, type)
  end

  def get(state, type, ids \\ []) do
    StateHandlers.get(state, type, ids)
  end

  def update(state, type, key, object) do
    StateHandlers.update(state, type, key, object)
    |> live_broadcast(:update, type)
  end

  def delete(state, type, id) do
    StateHandlers.delete(state, type, id)
  end

  def get_all_related_data(state, from_type, from_ids, to_type) do
    StateHandlers.get_related(state, from_type, from_ids, to_type)
  end

  ######################### Private functions #################################

  def live_broadcast({ state, data }, command, type) do
    #IO.puts("Broadcasting")
    Phoenix.PubSub.broadcast(
      :live_state,
      Atom.to_string(type),
      {
        type,
        command,
        Map.keys(data)
        |> Enum.at(0),
        Map.values(data)
        |> Enum.at(0)
      })
    { state, data }
  end
  def live_broadcast(state, :delete, id, type) do
    IO.puts("Broadcasting delete")
    Phoenix.PubSub.broadcast(
      :live_state,
      Atom.to_string(type),
      {
        :delete,
        type,
        id
      }
    )
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
