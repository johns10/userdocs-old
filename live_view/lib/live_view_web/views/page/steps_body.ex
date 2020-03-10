defmodule LiveViewWeb.Page.Steps.Body do
  # use LiveViewWeb, :view
  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.Version
  alias LiveViewWeb.InputHelpers
  alias LiveViewWeb.Step

  require Logger

  def render(assigns, page) do
    { assigns, result } = StateHandlers.get_related(
      assigns,
      :page_id,
      [ page ],
      :step
    )

    ordered_result =
      Enum.sort(result, &(&1.order <= &2.order))

    Enum.map(ordered_result,
      fn(object) ->
        content_tag(:li, [class: "list-group-item"]) do
          [
            content_tag(:div, [
              class: "d-flex w-100 justify-content-between",
              href: "#",
              phx_hook: "drop_zone",
              phx_click: "step::expand",
              phx_value_step_id: object.id
            ]) do
              Step.Header.render(
                object,
                assigns,
                "step::expand",
                "page",
                object.page_id
              )
            end,
            if object.id in assigns.active_steps do
              Step.Form.render(
                assigns.changesets.step[object.id] ,
                object,
                assigns,
                :form
              )
            else
              ""
            end
          ]
        end
      end
    )
  end
end
