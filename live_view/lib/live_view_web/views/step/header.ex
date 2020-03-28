defmodule LiveViewWeb.Step.Header do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Types
  alias LiveViewWeb.InputHelpers

  def render(step, assigns, action, parent_type, parent_id) do
    [
      content_tag(:h5, [ class: "mb-1" ]) do
        [
          Integer.to_string(step.order), ": ",
          Enum.find(assigns.step_type, nil, fn (o) -> o.id == step.step_type_id end) |> Map.get(:name)
        ]
      end,
      " (", Integer.to_string(step.id), "): ",
      step.storage_status, " ",
      step.record_status,
      content_tag(:i, [
        class: "fa fa-edit",
        phx_click: "draggable_hook",
        draggable: true
      ]) do
        ""
      end
    ]
  end
end


