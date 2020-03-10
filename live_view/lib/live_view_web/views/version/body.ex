defmodule LiveViewWeb.Version.Body do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias Userdocs.Version
  alias Userdocs.InputHelpers

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
            [
              _steps_header =
              content_tag(:h2, [
                class: "card-header",
                phx_click: "step::toggle_version_step_menu"
              ]) do
                "Version Steps"
              end,
              _steps =
                if assigns.ui.project_steps_menu.toggled == true do
                  content_tag(:div, [class: "card-body"]) do
                    LiveViewWeb.Version.Steps.render(assigns, Version.Constants.current(assigns))
                  end
                else
                  ""
                end,
              _project_step_menu_control =
                content_tag(:div, [class: "card-footer"]) do
                  Logger.debug(assigns.current_version_id)
                  LiveViewWeb.Version.StepsControl.render(
                    assigns, assigns.current_version_id)
                end
              || ""
            ]
          end
        end,
        _version_pages_menu = content_tag(:div, [class: "container-fluid"]) do
          _pages_header = content_tag(:div, [class: "card"]) do
            [
              _pages_header =
                content_tag(:h2, [class: "card-header"]) do
                  "Project Pages"
                end,
              _pages =
                content_tag(:div, [class: "card-body"]) do
                  LiveViewWeb.Version.Pages.render(assigns, Version.Constants.current(assigns))
                end,
              _pages_menu_control =
                content_tag(:div, [class: "card-footer"]) do
                  LiveViewWeb.Version.PagesControl.render(assigns, Version.Constants.current_id(assigns))
                end
              || ""
            ]
          end
        end
      ]
    else
    end
  end
end
