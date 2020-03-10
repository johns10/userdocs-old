defmodule LiveViewWeb.Project.Menu do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Types

  alias LiveViewWeb.Project

  def render(assigns) do
    current_project = Userdocs.Project.Constants.current(assigns)
    project_changesets = assigns.changesets["project"]
    dropdown_class =
      if assigns.ui.project_menu.toggled do
        "dropdown-menu show"
      else
        "dropdown-menu"
      end
    projects =
      Enum.filter(
        assigns.project,
        fn(p) ->
          (p.record_status != "removed")
          || (assigns.show_removed_projects == true)
        end
      )
    content_tag(:div, []) do
      content_tag(:div, [
        class: "btn-group",
        role: "group",
        aria_label: "Basic example",
      ]) do
        [
          content_tag(:button, [
            type: "button",
            class: "btn btn-secondary",
            phx_click: "project::edit",
            phx_value_id: assigns.current_project_id
          ]) do
            content_tag(:i, [ class: "fa fa-edit" ]) do
              ""
            end
          end,
          content_tag(:button, [
            class: "btn btn-secondary dropdown-toggle",
            type: "button",
            id: "projectMenuButton",
            data_toggle: "dropdown",
            aria_haspopup: "true",
            aria_expanded: "false",
            phx_click: "project::dropdown_toggle",
          ]) do
            current_project.name
          end,
          content_tag(:div, [
            class: dropdown_class,
            aria_labelledby: "projectMenuButton"
          ]) do
            [
              for project <- projects do
                content_tag(:a, [
                  class: "dropdown-item",
                  href: "#",
                  phx_click: "project::select",
                  phx_value_id: project.id
                ]) do
                  project.name
                end
              end,
              content_tag(:a, [
                class: "dropdown-item",
                href: "#",
                phx_click: "project::new",
              ]) do
                content_tag(:i, [
                  class: "fa fa-plus"
                ]) do
                  "New Project"
                end
              end
            ]
          end
        ]
      end
    end
  end
end
