defmodule LiveViewWeb.Pages.Footer do
    # use LiveViewWeb, :view
    use Phoenix.LiveView
    use Phoenix.HTML
  
    require Logger
  
    alias LiveViewWeb.Page
  
    def render(assigns, parent_id) do
      current_changeset_id = assigns.current_changesets.new_version_pages[parent_id]
      current_changeset = assigns.changesets.page[current_changeset_id]
      content_tag(:div, [class: "card-footer"]) do
        if assigns.ui.version_page_control.mode == :button do
          Page.Control.New.render(assigns, parent_id)
        else
          Page.Form.render(assigns, current_changeset, parent_id)
        end
      end
    end
  
  end
  