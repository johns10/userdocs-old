defmodule LiveViewWeb.Page.Elements.Footer do
  # use LiveViewWeb, :view
  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.Element

  require Logger

  def render(assigns, page) do
    if (assigns.ui.page_element_forms[page.id] != nil &&
      assigns.ui.page_element_forms[page.id].mode == :new
    ) do
      changeset_id = assigns.current_changesets.new_page_elements[page.id]
      changeset = assigns.changesets.element[changeset_id]
      LiveViewWeb.Element.Form.render(assigns, changeset, page)
    else
      LiveViewWeb.Element.Control.New.render(assigns, page.id)
    end
  end
end
