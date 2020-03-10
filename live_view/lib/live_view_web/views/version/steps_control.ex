defmodule LiveViewWeb.Version.StepsControl do
  # use LiveViewWeb, :view
  use Phoenix.LiveView
  use Phoenix.HTML

  require Logger

  alias LiveViewWeb.Page

  def render(assigns, version_id) do
    if assigns.ui.version_step_form.toggled == false do
      LiveViewWeb.StepView.render(
        assigns.current_version_id,
        assigns,
        :new_step_button
      )
    else
      version_id = Map.get(LiveViewWeb.Version.current(assigns), :id)
      step = Userdocs.Data.get_one(
          assigns,
          :step,
          assigns.current_changesets.new_version_steps[version_id]
        )
      new_step_changeset = assigns.changesets.step[
        assigns.current_changesets.new_version_steps[version_id]]
      LiveViewWeb.StepView.render(
        new_step_changeset,
        step,
        assigns,
        :empty_header_form
      )
    end
  end

end
