defmodule LiveViewWeb.Version.Steps do
  # use LiveViewWeb, :view
  use Phoenix.LiveView
  use Phoenix.HTML

  require Logger

  alias Userdocs.Version
  alias LiveViewWeb.StepView

  def render(assigns, version) do
    { assigns, result } = StateHandlers.get_related(
      assigns,
      :version_id,
      [ version ],
      :step
    )

    ordered_result =
      Enum.sort(result, &(&1.order <= &2.order))

    content_tag(:div, []) do
      if LiveViewWeb.Version.current(assigns) == nil do
        ""
      else
        for step <- ordered_result do
          if (step.storage_status == "web") do
            ""
          else
            content_tag(:li, [class: "list-group-item"]) do
              if step.id in assigns.active_steps do
                StepView.render(
                  assigns.changesets.step[step.id],
                  step,
                  assigns,
                  :header_form,
                  "step::expand",
                  "version",
                  step.version_id
                )
              else
                StepView.render(
                  step,
                  assigns,
                  "version",
                  version.id,
                  :header_only,
                  "step::expand"
                )
              end
            end
          end
        end
      end
    end
  end

end
