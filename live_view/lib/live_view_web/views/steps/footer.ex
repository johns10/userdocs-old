
defmodule LiveViewWeb.Steps.Footer do

  require Logger

  # use LiveViewWeb, :view
  use Phoenix.LiveView
  use Phoenix.HTML

  require Logger

  alias LiveViewWeb.Page
#TODO: change this to the new gear (check elements)
  def render(assigns, parent_type, parent_id, new_step_id) do
    parent = Userdocs.Data.get_one(assigns, parent_type, parent_id)
    parent_fk = String.to_atom(Atom.to_string(parent_type) <> "_id")
    form_atom = String.to_atom(Atom.to_string(parent_type) <> "_step_form")

    new_step_changeset = assigns.changesets.step[new_step_id]

    #Logger.debug("Rendering Steps Footer")
    #Logger.debug(inspect(parent))
    #Logger.debug(parent_fk)
    #Logger.debug(new_step_id)
    #Logger.debug(inspect(new_step_changeset))
    #Logger.debug(form_atom)
    #Logger.debug(inspect(assigns.ui[form_atom]))

    if assigns.ui[form_atom][parent_id].mode == :button do
      LiveViewWeb.Step.Control.New.render(
        assigns,
        parent_type,
        parent_id
      )
    else
      step = Userdocs.Data.get_one(
        assigns,
        :step,
        new_step_id
      )
      LiveViewWeb.StepView.render(
        new_step_changeset,
        step,
        assigns,
        :empty_header_form
      )
    end
  end
end

