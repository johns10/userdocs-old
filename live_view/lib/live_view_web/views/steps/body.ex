defmodule LiveViewWeb.Steps.Body do
  # use LiveViewWeb, :view
  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.InputHelpers
  alias LiveViewWeb.Step

  require Logger

  def render(assigns, parent_type, parent_id) do
    Logger.debug("Rendering Steps Body")
    parent = Userdocs.Data.get_one(assigns, parent_type, parent_id)
    parent_fk = String.to_atom(Atom.to_string(parent_type) <> "_id")

    { assigns, result } = StateHandlers.get_related(
      assigns,
      parent_fk,
      [ parent ],
      :step
    )

    ordered_result =
      Enum.sort(result, &(&1.order <= &2.order))

    Enum.map(ordered_result,
      fn(object) ->
        LiveViewWeb.Step.WholeStep.render(object, assigns, parent_type, parent_id)
      end
    )
  end
end
