defmodule LiveViewWeb.Step.Header do
  use Phoenix.LiveView
  use Phoenix.HTML

  require Logger

  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Types
  alias LiveViewWeb.InputHelpers

  def render(step, assigns, action, parent_type, parent_id) do
    content_tag(:div, [
      class: "d-flex w-100 justify-content-between",
      phx_click: "step::expand",
      phx_value_step_id: step.idz
    ]) do
      [
        content_tag(:h5, [class: "mb-1"]) do
          [
            Integer.to_string(step.order), ": ",
            Enum.find(assigns.step_type, nil, fn (o) -> o.id == step.step_type_id end) |> Map.get(:name),
            " (", Integer.to_string(step.id), "): ",
            step.storage_status, " ",
            step.record_status,
          ]
        end,
        content_tag(:i, [
          class: "fa fa-edit",
          href: "#",
          phx_click: "step::expand"
        ]) do
          ""
        end
      ]
    end
  end
  
end


