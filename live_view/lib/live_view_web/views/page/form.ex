defmodule LiveViewWeb.Page.Form do
  # use LiveViewWeb, :view
  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.Version
  alias LiveViewWeb.InputHelpers

  require Logger

  def render(assigns, changeset, parent_id) do
    f = form_for(changeset, '#', [  ])
    content_tag(:form, [phx_submit: :"page::save", phx_change: :"page::validate"]) do
      [
        content_tag(:p, []) do
          f.params["storage_status"] <> ", face " <> f.params["record_status"]
        end,
        hidden_input(f, :id, value: f.params["id"]),
        hidden_input(f, :version_id, value: f.params["version_id"]),
        hidden_input(f, :storage_status, value: f.params["storage_status"]),
        hidden_input(f, :record_status, value: f.params["record_status"]),
        InputHelpers.input(f, :url,
          using: :text_input,
          value: f.params["url"],
          id: "version-page::url::text-input",
          placeholder: "www.google.com"
        ),
        content_tag(:div, [ class: "modal-footer" ]) do
          [
            InputHelpers.button_save(f),
            InputHelpers.button_remove("page", changeset.changes.id),
            InputHelpers.button_cancel("page", changeset.changes.id)
            || ""
          ]
        end
        || ""
      ]
    end
  end
end
