defmodule LiveViewWeb.Step.Form do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Types
  alias LiveViewWeb.InputHelpers

  require Logger

  def render(step_changeset, step, assigns) do
    f = form_for(step_changeset, "#", [  ])
    Logger.debug("Rendering Step Form")
    content_tag(:form, [ phx_submit: :"step::save", phx_change: :"step::validate" ]) do
      [
        hidden_input(f, :id, [value: f.params["id"]]),
        hidden_input(f, :storage_status, [value: f.params["storage_status"]]),
        hidden_input(f, :record_status, [value: f.params["record_status"]]),
        hidden_input(f, :version_id, [value: f.params["version_id"]]),
        hidden_input(f, :annotation_id, [value: f.params["annotation_id"]]),
        hidden_input(f, :page_id, [value: f.params["page_id"]]),
        hidden_input(f, :order, [value: f.params["order"]]),
        content_tag(:div, [ class: "form-group form-row align-items-center" ]) do
          [
            content_tag(:div, [ class: "col-sm-3 my-1" ]) do
              [
                content_tag(:label, []) do
                  "Step Type"
                end,
                select(f, :step_type_id, Helpers.select(assigns, :step_type), [
                  value: f.params["step_type_id"],
                  class: "form-control"
                ])
              ]
            end,
            inputs_for(f, :args,
              fn fp ->
                step_id = Integer.to_string(Helpers.get_id(f.params["id"]))
                LiveViewWeb.ArgView.render(
                  fp.params["key"],
                  fp.params["value"],
                  fp,
                  step_id,
                  assigns
                )
              end
            )
          ]
        end,
        content_tag(:div, [ class: "modal-footer" ]) do
          [
            InputHelpers.button_save(f),
            InputHelpers.button_remove("step", step_changeset.changes.id),
            InputHelpers.button_cancel("step", step_changeset.changes.id)
            || ""
          ]
        end
        || ""
      ]
    end
  end
end

