
defmodule LiveViewWeb.Page.Steps.Footer do
  # use LiveViewWeb, :view
  use Phoenix.LiveView
  use Phoenix.HTML

  require Logger

  alias LiveViewWeb.Page
#TODO: change this to the new gear (check elements)
  def render(assigns, page_id) do
    if assigns.ui.version_page_menu.toggled == false do
      LiveViewWeb.StepView.render(
        page_id,
        assigns,
        :new_step_button
      )
    else
      step = Userdocs.Data.get_one(
          assigns,
          :step,
          assigns.current_changesets.new_version_pages[page_id]
        )
      new_step_changeset = assigns.changesets.step[
        assigns.current_changesets.new_version_pages[page_id]]
      LiveViewWeb.StepView.render(
        new_step_changeset,
        step,
        assigns,
        :empty_header_form
      )
    end
  end

end

