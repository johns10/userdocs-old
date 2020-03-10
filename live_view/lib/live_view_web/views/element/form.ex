defmodule LiveViewWeb.Element.Form do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.Version
  alias LiveViewWeb.InputHelpers

  require Logger

  def render(assigns, changeset, parent_id) do
    f = form_for(changeset, '#', [  ])
    Logger.debug("Rendering Element Form")
    content_tag(:form, [phx_submit: :"element::save", phx_change: :"element::validate"]) do
      [
        hidden_input(f, :id, value: f.params["id"]),
        hidden_input(f, :page_id, value: f.params["page_id"]),
        hidden_input(f, :storage_status, value: f.params["storage_status"]),
        hidden_input(f, :record_status, value: f.params["record_status"]),
        InputHelpers.input(f, :name,
          using: :text_input,
          value: f.params["name"],
          id: "element::name::text-input",
          placeholder: "Element Name"
        ),
        InputHelpers.input(f, :strategy,
          [
            using: :select,
            select_options: [ "xpath", "id" ],
            value: f.params["strategy"],
            id: "element::strategy::select",
            placeholder: :id
          ]
        ),
        InputHelpers.input(f, :selector,
          using: :text_input,
          value: f.params["selector"],
          id: "element::selector::text-input",
          placeholder: "Element Selector"
        ),
        content_tag(:div, [ class: "modal-footer" ]) do
          [
            InputHelpers.button_save(f),
            InputHelpers.button_remove("element", changeset.changes.id),
            InputHelpers.button_cancel("element", changeset.changes.id)
            || ""
          ]
        end
        || ""
      ]
    end
  end
end
