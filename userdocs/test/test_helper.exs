ExUnit.start()
defmodule TestHelper do
  defmacro test_data() do
    quote do
      %{
        current_project_id: nil,
        page_edit: [],
        active_steps: [],
        active_pages: [],
        active_elements: [],
        active_page_elements: [],
        changesets: %{
          project: %{},
          version: %{},
          step: %{},
          page: %{},
          element: %{},
          content: %{},
          annotation: %{},
          content: %{}
        },
        current_changesets: %{
          new_project: nil,
          new_project_versions: %{},
          new_version_steps: %{},
          new_version_pages: %{},
          new_page_elements: %{},
          new_page_annotations: %{},

        },
        ui: %{
          content_menu: %{
            toggled: false
          },
          content_form: %{
            toggled: false,
            mode: :new,
            new: nil
          },
          version_menu: %{
            toggled: false
          },
          page_dropdown: %{
            active: nil,
          },
          version_form: %{
            toggled: false,
            mode: :new,
            new: nil
          },
          project_menu: %{
            toggled: false
          },
          project_form: %{
            toggled: false,
            mode: :new,
            new: nil
          },
          version_step_form: %{
            toggled: false,
            new: nil
          },
          version_page_control: %{
            mode: :button
          },
          page_element_forms: %{

          }
        },
        team: [
          %Storage.Team{
            id: 2,
            name: "FunnelCloud",
          }
        ],
        project: [
          %Storage.Project{
            id:           1,
            storage_status: "state",
            record_status:  "active",
            name:         "Test Project",
            base_url:     "http://webdriveruniversity.com/",
            project_type: "Web",
            team_id:      1
          },
          %Storage.Project{
            id:           2,
            storage_status: "state",
            record_status:  "active",
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
            record_status:  "active"
          },
          %Storage.Version{
            id:         2,
            name:    "1.1",
            project_id: 1,
            storage_status: "state",
            record_status:  "active"
          },
          %Storage.Version{
            id:         3,
            name:    "1.3",
            project_id: 2,
            storage_status: "state",
            record_status:  "active"
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
            step_type_id:   1,
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
                key:      "strategy",
                value:    "xpath",
              },
              %Storage.Arg{
                key:      "selector",
                value:    ~s|/html/body/div[@class='ember-view']/div[9]/div//form//button[1]|,
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
            id:             3,
            storage_status:  "state",
            record_status:  "existing",
            order:          3,
            args: [
              %Storage.Arg{
                key:      "strategy",
                value:    "xpath",
              },
              %Storage.Arg{
                key:      "selector",
                value:    ~s|/html/body/div[@class='ember-view']/div[9]/div//form//button[contains(.,'Next')]|,
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
            id:             4,
            storage_status:  "state",
            record_status:  "existing",
            order:          4,
            args: [
              %Storage.Arg{
                key:      "strategy",
                value:    "xpath",
              },
              %Storage.Arg{
                key:      "selector",
                value:    ~s|/html/body/div[@class='ember-view']/div[9]/div//form//div[@class='modal-container']/div/div[@class='content']/div/div[1]/div[3]|,
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
            id:             5,
            storage_status:  "state",
            record_status:  "existing",
            order:          5,
            args: [
              %Storage.Arg{
                key:      "strategy",
                value:    "xpath",
              },
              %Storage.Arg{
                key:      "selector",
                value:    ~s|/html/body/div[@class='ember-view']/div[9]/div//form//div[@class='modal-container']/div/div[@class='content']/div/div[1]/div[3]|,
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
        ],
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
            name:               "Google Guidelines",
            label:              "1",
            description:        "This is the google guidelines.",
            annotation_type_id: 1,
            page_id:            1
          },
          %Storage.Annotation{
            id:                 2,
            name:               "Page Speed",
            description:        "This is the page speed.",
            label:              "2",
            annotation_type_id: 2,
            page_id:            1
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
            args: ["strategy", "selector"]
          },
          %Storage.StepType{
            id: 4,
            name: "Click",
            args: ["strategy", "selector"]
          },
          %Storage.StepType{
            id: 5,
            name: "Fill Field",
            args: ["strategy", "selector", "text"]
          },
          %Storage.StepType{
            id: 6,
            name: "Javascript",
            args: ["procedure", "types", "text"]
          }
        ],
        page: [
          %Storage.Page{
            id:         1,
            storage_status:  "state",
            record_status:  "existing",
            url:        "https://varvy.com/pagespeed/wicked-fast.html",
            version_id: 1
          },
          %Storage.Page{
            id:         2,
            storage_status:  "state",
            record_status:  "existing",
            url:        "https://staging.app.funnelcloud.io/#/plant/All/overview/at-a-glance",
            version_id: 2
          },
          %Storage.Page{
            id:         3,
            storage_status:  "state",
            record_status:  "existing",
            url:        "https://staging.app.funnelcloud.io/#/machines/1",
            version_id: 2
          },
        ],
        element: [
          %Storage.Element{
            id:             1,
            storage_status:  "state",
            record_status:  "existing",
            name: "Google Guidelines",
            strategy: "xpath",
            selector: ~s|//div[@id='menu']/ul//a[@href='/']|,
            page_id: 1

          },
          %Storage.Element{
            id:             2,
            storage_status:  "state",
            record_status:  "existing",
            strategy: "xpath",
            selector: ~s|//div[@id='menu']/ul//a[@href='/']|,
            page_id: 1
          }

        ],
      }
    end
  end

  defmacro project_form_1() do
    quote do
      %{
        "base_url" => "https://www.test.com",
        "id" => "2",
        "name" => "Test",
        "project_type" => "Test",
        "record_status" => "active",
        "storage_status" => "",
        "team_id" => "1"
      }
    end
  end

  defmacro version_form_existing() do
    quote do
      %{
        "id" => "1",
        "name" => "0.0",
        "project_id" => "1",
        "record_status" => "active",
        "storage_status" => "state",
      }
    end
  end

  defmacro step_form_existing() do
    quote do
      %{
        "annotation_id" => "",
        "args" =>
          %{
            "0" => %{"key" => "strategy", "value" => "xpath"},
            "1" => %{"key" => "selector", "value" => "/html/body/div[@class='ember-view']/div[9]/div//form//button[contains(.,'Next Page')]"}
          },
        "id" => "6",
        "order" => "6",
        "page_id" => "",
        "record_status" => "existing",
        "step_type_id" => "2",
        "storage_status" => "state",
        "version_id" => "1"
      }
    end
  end

  defmacro page_form_existing() do
    quote do
      %{
        "id" => "1",
        "record_status" => "existing",
        "storage_status" => "state",
        "url" => "www.test.com",
        "version_id" => "1"
      }
    end
  end

  defmacro element_form_existing() do
    quote do
      %{
        "id" => "10936504",
        "name" => "fdsa",
        "page_id" => "1",
        "record_status" => "new",
        "selector" => "fdsadfsa",
        "storage_status" => "web",
        "strategy" => "xpath"
      }
    end
  end

  defmacro content_form_existing() do
    quote do
      %{
        "id" => "10936504",
        "storage_status" => "web",
        "record_status" => "new",
        "name" => "asdfafg",
        "description" => "asdwrwrh",
        "team_id" => "1"
      }
    end
  end
end
