defmodule LiveViewWeb.Content.Form do
  require Logger

  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.ErrorHelpers
  alias LiveViewWeb.InputHelpers

  def render(changeset, object, assigns) do
    f = form_for(changeset, "#", [  ])
    Logger.debug("Rendering Content Form")
    content_tag(:form, [
      class: "form-group",
      phx_submit: :"content::save",
      phx_change: :"content::validate"
    ]) do
      [
        hidden_input(f, :id, [value: f.params["id"]]),
        hidden_input(f, :storage_status, [value: f.params["storage_status"]]),
        hidden_input(f, :record_status, [value: f.params["record_status"]]),
        hidden_input(f, :team_id, [value: f.params["team_id"]]),
        content_tag(:div, [ class: "form-group form-row align-items-center" ]) do
          [
            content_tag(:div, [ class: "col-sm-12 my-1" ]) do
              InputHelpers.input(f, :name,
                using: :text_input,
                value: f.params["name"],
                id: "content::name::text-input",
                placeholder: "Name"
              )
            end,
            content_tag(:div, [ class: "col-sm-12 my-1" ]) do
              InputHelpers.input(f, :description,
                using: :text_input,
                value: f.params["description"],
                id: "content::description::text-input",
                placeholder: "Description"
              )
            end
          ]
        end,
        content_tag(:div, [ class: "modal-footer" ]) do
          [
            InputHelpers.button_save(f),
            InputHelpers.button_remove("content", changeset.changes.id),
            InputHelpers.button_cancel("content", changeset.changes.id)
            || ""
          ]
        end
        || ""
      ]
    end
  end
end
