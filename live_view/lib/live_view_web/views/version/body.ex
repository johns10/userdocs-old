defmodule LiveViewWeb.Version.Body do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias Userdocs.Version
  alias Userdocs.InputHelpers
  alias LiveViewWeb.Steps
  alias LiveViewWeb.Pages

  require Logger

  def render(assigns) do
    if assigns.current_version_id != nil do
      [
        _version_steps_menu = content_tag(:div, [class: "container-fluid"]) do
          psm_menu_class =
            if assigns.ui.project_steps_menu.toggled == true do
              "collapse show"
            else
              "collapse"
            end

          _version_header = content_tag(:div, [class: "card"]) do
            current_version = Version.Constants.current(assigns)
            [
              Steps.Header.render(assigns, "version", current_version.id),
              if current_version.id in assigns.active_version_steps do
                new_step_id = assigns.current_changesets.new_version_steps[current_version.id]
                [
                  content_tag(:ul, [ class: "card-body" ]) do
                    content_tag(:ul, [ class: "list-group" ]) do
                      Steps.Body.render(assigns, :version, current_version.id)
                    end
                  end,
                  content_tag(:div, [ class: "card-footer" ]) do
                    Steps.Footer.render(assigns, :version, current_version.id, new_step_id)
                  end
                ]
              else
                ""
              end,
            ]
          end
        end,
        _version_pages_menu = content_tag(:div, [class: "container-fluid"]) do
          _pages_header = content_tag(:div, [class: "card"]) do
            [
              Pages.Header.render(assigns),
              Pages.Body.render(assigns, Version.Constants.current(assigns)),
              Pages.Footer.render(assigns, Version.Constants.current_id(assigns))
            ]
          end
        end
      ]
    else
    end
  end
end
