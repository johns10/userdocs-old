defmodule State.State do

  defstruct(
    user: [
      %Storage.Users.User{
        current_password: nil,
        email: "johns10davenport@gmail.com",
        id: 1,
        inserted_at: ~N[2019-12-24 15:08:53],
        password: nil,
        password_hash: "$pbkdf2-sha512$100000$iyJxvjj7CZ1ccwBgGxWEmQ==$uytDjvG7F3+Ql86zZNGK6gfjpl3MjUmhgP7qX8Q/g5JzRW5jAREsrmLn0P3+16ewvqpdPnbyXVRo2uLTOyrUeA==",
        updated_at: ~N[2019-12-24 15:08:53]
      }
    ],
    team_user: [
        %Storage.TeamUser{
          user_id: 1,
          team_id: 1
      },
    ],
    team: [
      %Storage.Team{
        id: 1,
        name: "Test",
      },
      %Storage.Team{
        id: 2,
        name: "FunnelCloud",
      }
    ],
    project: [
      %Storage.Project{
        id:           1,
        storage_status: "state",
        record_status:  "existing",
        name:         "Test Project",
        base_url:     "http://webdriveruniversity.com/",
        project_type: "Web",
        team_id:      1
      },
      %Storage.Project{
        id:           2,
        storage_status: "state",
        record_status:  "existing",
        name:         "FunnelCloud Staging",
        base_url:     "https://staging.app.funnelcloud.io",
        project_type: "Web",
        team_id:      1
      },
    ],
    version: [
      %Storage.Version{
        id:         1,
        name:    "1.0",
        project_id: 1,
        storage_status: "state",
        record_status:  "existing"
      },
      %Storage.Version{
        id:         2,
        name:    "1.1",
        project_id: 1,
        storage_status: "state",
        record_status:  "existing"
      },
      %Storage.Version{
        id:         3,
        name:    "1.3",
        project_id: 2,
        storage_status: "state",
        record_status:  "existing"
      }
    ],
    page: [
      %Storage.Page{
        id:         1,
        storage_status: "state",
        record_status:  "existing",
        url:        "https://varvy.com/pagespeed/wicked-fast.html",
        version_id: 1
      },
      %Storage.Page{
        id:         2,
        storage_status: "state",
        record_status:  "existing",
        url:        "https://staging.app.funnelcloud.io/#/plant/All/overview/at-a-glance",
        version_id: 2
      },
      %Storage.Page{
        id:         3,
        storage_status: "state",
        record_status:  "existing",
        url:        "https://staging.app.funnelcloud.io/#/machines/1",
        version_id: 2
      },
    ],
    step_type: [
      %Storage.StepType{
        id: 1,
        name: "",
        args: []
      },
      %Storage.StepType{
        id:   2,
        name: "Navigate",
        args: [ "url" ]
      },
      %Storage.StepType{
        id: 3,
        name: "Wait",
        args: ["element"]
      },
      %Storage.StepType{
        id: 4,
        name: "Click",
        args: ["element"]
      },
      %Storage.StepType{
        id: 5,
        name: "Fill Field",
        args: ["element", "text"]
      },
      %Storage.StepType{
        id: 6,
        name: "Apply Annotation",
        args: [ "element", "annotation_type" ]
      }
    ],
    element: [
      %Storage.Element{
        id:             1,
        storage_status:  "state",
        record_status:  "existing",
        name: "Google Guidelines",
        strategy: "xpath",
        selector: ~s|//div[@id='menu']/ul//a[@href='/']|,
        page_id: 1,
        page: nil
      },
      %Storage.Element{
        id:             2,
        storage_status:  "state",
        record_status:  "existing",
        name: "Something Fast",
        strategy: "xpath",
        selector: ~s|//div[@id='menu']/ul//a[@href='/']|,
        page_id: 1,
        page: nil
      }

    ],
    step: [
      %Storage.Step{
        id:             1,
        storage_status:  "state",
        record_status:  "existing",
        order:          1,
        args: [
          %Storage.Arg{
            key:      "url",
            value:    "https://staging.app.funnelcloud.io/#/setup",
          },
        ],
        step_type:      nil,
        step_type_id:   2,
        version:        nil,
        version_id:     1,
        page:           nil,
        page_id:        nil,
        annotation:     nil,
        annotation_id:  nil

      },
      %Storage.Step{
        id:             2,
        storage_status:  "state",
        record_status:  "existing",
        order:          2,
        args: [
          %Storage.Arg{
            key: "element",
            value: 1,
          },
        ],
        step_type:      nil,
        step_type_id:   3,
        version:        nil,
        version_id:     1,
        page:           nil,
        page_id:        nil,
        annotation:     nil,
        annotation_id:  nil
      },
      %Storage.Step{
        id:             3,
        storage_status:  "state",
        record_status:  "existing",
        order:          3,
        args: [
          %Storage.Arg{
            key: "element",
            value: 1,
          },
        ],
        step_type:      nil,
        step_type_id:   4,
        version:        nil,
        version_id:     1,
        page:           nil,
        page_id:        nil,
        annotation:     nil,
        annotation_id:  nil
      },
      %Storage.Step{
        id:             4,
        storage_status:  "state",
        record_status:  "existing",
        order:          4,
        args: [
          %Storage.Arg{
            key: "element",
            value: 1,
          },
        ],
        step_type:      nil,
        step_type_id:   5,
        version:        nil,
        version_id:     1,
        page:           nil,
        page_id:        nil,
        annotation:     nil,
        annotation_id:  nil
      },
      %Storage.Step{
        id:             5,
        storage_status:  "state",
        record_status:  "existing",
        order:          5,
        args: [
          %Storage.Arg{
            key: "element",
            value: 1,
          },
          %Storage.Arg{
            key: "annotation",
            value: 1,
          },
        ],
        step_type:      nil,
        step_type_id:   6,
        version:        nil,
        version_id:     1,
        page:           nil,
        page_id:        nil,
        annotation:     nil,
        annotation_id:  nil
      },
      %Storage.Step{
        id:             6,
        storage_status:  "state",
        record_status:  "existing",
        order:          6,
        args: [
          %Storage.Arg{
            key: "element",
            value: 1,
          },
        ],
        step_type:      nil,
        step_type_id:   3,
        version:        nil,
        version_id:     1,
        page:           nil,
        page_id:        nil,
        annotation:     nil,
        annotation_id:  nil
      },
      %Storage.Step{
        id:             7,
        storage_status:  "state",
        record_status:  "existing",
        order:          7,
        args: [
          %Storage.Arg{
            key: "element",
            value: 1,
          },
          %Storage.Arg{
            key: "annotation",
            value: 1,
          },
        ],
        step_type:      nil,
        step_type_id:   6,
        version:        nil,
        version_id:     1,
        page:           nil,
        page_id:        nil,
        annotation:     nil,
        annotation_id:  nil
      },
      %Storage.Step{
        id:             8,
        storage_status:  "state",
        record_status:  "existing",
        order:          8,
        args: [
          %Storage.Arg{
            key: "element",
            value: 1,
          },
        ],
        step_type:      nil,
        step_type_id:   3,
        version:        nil,
        version_id:     1,
        page:           nil,
        page_id:        nil,
        annotation:     nil,
        annotation_id:  nil
      },
      %Storage.Step{
        id:             9,
        storage_status:  "state",
        record_status:  "existing",
        order:          9,
        args: [
          %Storage.Arg{
            key: "element",
            value: 1,
          },
        ],
        step_type:      nil,
        step_type_id:   4,
        version:        nil,
        version_id:     1,
        page:           nil,
        page_id:        nil,
        annotation:     nil,
        annotation_id:  nil
      },
      %Storage.Step{
        id:             10,
        storage_status:  "state",
        record_status:  "existing",
        order:          10,
        args: [
          %Storage.Arg{
            #id:       18,
            #step_id:  10,
            key:      "url",
            value:    "https://staging.app.funnelcloud.io/#/login",
          },
        ],
        step_type:      nil,
        step_type_id:   2,
        version:        nil,
        version_id:     1,
        page:           nil,
        page_id:        nil,
        annotation:     nil,
        annotation_id:  nil
      },
      %Storage.Step{
        id:             11,
        storage_status:  "state",
        record_status:  "existing",
        order:          11,
        args: [
          %Storage.Arg{
            key: "element",
            value: 1,
          },
        ],
        step_type:      nil,
        step_type_id:   3,
        version:        nil,
        version_id:     1,
        page:           nil,
        page_id:        nil,
        annotation:     nil,
        annotation_id:  nil
      },
      %Storage.Step{
        id:             12,
        storage_status:  "state",
        record_status:  "existing",
        order:          12,
        args: [
          %Storage.Arg{
            key: "element",
            value: 1,
          },
          %Storage.Arg{
            key:      "text",
            value:    "admin@funnelcloud.io",
          },
        ],
        step_type:      nil,
        step_type_id:   5,
        version:        nil,
        version_id:     1,
        page:           nil,
        page_id:        nil,
        annotation:     nil,
        annotation_id:  nil
      },
      %Storage.Step{
        id:             13,
        storage_status:  "state",
        record_status:  "existing",
        order:          13,
        args: [
          %Storage.Arg{
            key: "element",
            value: 1,
          },
          %Storage.Arg{
            key:      "text",
            value:    "FirstTimer",
          },
        ],
        step_type:      nil,
        step_type_id:   5,
        version:        nil,
        version_id:     1,
        page:           nil,
        page_id:        nil,
        annotation:     nil,
        annotation_id:  nil
      },
      %Storage.Step{
        id:             14,
        storage_status:  "state",
        record_status:  "existing",
        order:          14,
        args: [
          %Storage.Arg{
            key: "element",
            value: 1,
          },
        ],
        step_type:      nil,
        step_type_id:   4,
        version:        nil,
        version_id:     1,
        page:           nil,
        page_id:        nil,
        annotation:     nil,
        annotation_id:  nil
      },
      %Storage.Step{
        id:             15,
        storage_status:  "state",
        record_status:  "existing",
        order:          1,
        args: [
          %Storage.Arg{
            key:      "url",
            value:    "https://varvy.com/pagespeed/wicked-fast.html",
          },
        ],
        step_type_id:   2,
        version_id:     nil,
        page_id:        3,
        annotation_id:  nil
      },
      %Storage.Step{
        id:             19,
        storage_status:  "state",
        record_status:  "existing",
        order:          5,
        #step_type:      :page_screenshot,
        args: %{

        },
        step_type_id:   6,
        version_id:     nil,
        page_id:        3,
        annotation_id:  nil
      },
      %Storage.Step{
        id:           20,
        storage_status:  "state",
        record_status:  "existing",
        order:        1,
        step_type_id:   2,
        version_id:     nil,
        page_id:        1,
        annotation_id:  nil,
        args: [
          %Storage.Arg{
            key:      "url",
            value:    "https://varvy.com/pagespeed/wicked-fast.html",
          },
        ],
      },
      %Storage.Step{
        id:           21,
        storage_status:  "state",
        record_status:  "existing",
        order:        2,
        step_type_id:   3,
        version_id:     nil,
        page_id:        1,
        annotation_id:  nil,
        args: [
          %Storage.Arg{
            key: "element",
            value: 1,
          }
        ],
      },
      %Storage.Step{
        id:             22,
        storage_status:  "state",
        record_status:  "existing",
        order:          3,
        step_type_id:   6,
        version_id:     nil,
        page_id:        1,
        annotation_id:  nil,
        args: [
          %Storage.Arg{
            key: "element",
            value: 1,
          },
          %Storage.Arg{
            key: "annotation",
            value: 1,
          },
        ],
      },
      %Storage.Step{
        id:             23,
        storage_status:  "state",
        record_status:  "existing",
        order:          4,
        step_type_id:   6,
        version_id:     nil,
        page_id:        1,
        annotation_id:  nil,
        args: [
          %Storage.Arg{
            key: "element",
            value: 1,
          },
          %Storage.Arg{
            key: "annotation",
            value: 1,
          },
        ],
      },
      %Storage.Step{
        id:             24,
        storage_status:  "state",
        record_status:  "existing",
        order:          5,
        step_type_id:   6,
        version_id:     nil,
        page_id:        1,
        annotation_id:  nil,
        args: [
          %Storage.Arg{
            key: "element",
            value: 1,
          },
          %Storage.Arg{
            key:      "script_type",
            value:    "badge",
          },
          %Storage.Arg{
            key: "annotation",
            value: 1,
          },
        ],
      },
      %Storage.Step{
        id:             25,
        storage_status:  "state",
        record_status:  "existing",
        order:          6,
        step_type_id:   6,
        version_id:     nil,
        page_id:        1,
        annotation_id:  nil,
        args: [
          %Storage.Arg{
            key: "element",
            value: 1,
          },
          %Storage.Arg{
            key:      "script_type",
            value:    "outline",
          },
          %Storage.Arg{
            key:      "thickness",
            value:    3,
          },
          %Storage.Arg{
            key:      "color",
            value:    "red"
          },
        ],
      },
    ],
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
    annotation_type: [
      %Storage.AnnotationType{
        id:   1,
        name: "Outline"
      },
      %Storage.AnnotationType{
        id:   2,
        name: "Badge"
      }
    ],
    annotation: [
      %Storage.Annotation{
        id:                 1,
        name:              "1",
        annotation_type_id: 1,
        element_id:         1,
        page_id:            1,
        content_id:         1
      },
      %Storage.Annotation{
        id:                 2,
        name:              "2",
        annotation_type_id: 2,
        element_id:         2,
        page_id:            1,
        content_id:         2
      }
    ],
    content: [
      %Storage.Content{
        id: 1,
        storage_status: "state",
        record_status:  "existing",
        name:           "Google Guidelines",
        description:    "This is the google guidelines.",
        team_id:      1
      },
      %Storage.Content{
        id: 2,
        storage_status: "state",
        record_status:  "existing",
        name:           "Page Speed",
        description:    "This is the page speed.",
        team_id:      1
      }
    ],
    job: %{
    },
    task: %{
    }
  )

  def new_state() do
    %State.State{}
  end

  def create(state, type, object) do
    object = Map.put(object, :storage_status, "state")
    object = Map.put(object, :record_status, "existing")
    StateHandlers.create(state, type, object)
    |> live_broadcast(:create, type)
  end

  def get(state, type, ids \\ []) do
    StateHandlers.get(state, type, ids)
  end

  def update(state, type, object) do
    StateHandlers.update(state, type, object)
    |> live_broadcast(:update, type)
  end

  def delete(state, type, object) do
    StateHandlers.delete(state, type, object)
  end

  def get_all_related_data(state, from_type, from_data, to_type) do
    StateHandlers.get_related(state, from_type, from_data, to_type)
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
        Enum.at(data, 0)
      })
    { state, data }
  end
  def live_broadcast(_state, :delete, id, type) do
    #IO.puts("Broadcasting delete")
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
end
