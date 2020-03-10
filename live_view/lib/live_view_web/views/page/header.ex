defmodule LiveViewWeb.Page.Header do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.Page
  alias LiveViewWeb.InputHelpers

  def render(assigns, changeset, page) do
    show =
      if assigns.ui.page_dropdown.active == page.id do
        " show"
      else
        ""
      end
    header_action =
      if page.id in assigns.page_edit do
        ""
      else
        "page::expand"
      end
    _header = content_tag(:div, [
      class: "card-header",
      href: "#",
      phx_click: header_action,
      phx_value_id: page.id
    ]) do
      if (page.id in assigns.page_edit) do
        f = form_for(changeset, '#', [  ])
        content_tag(
          :form,
          [
            class: "d-flex",
            phx_submit: :"page::save",
            phx_change: :"page::validate"
          ]
        ) do
          [
            content_tag :div, [class: "p-2"] do
              InputHelpers.button_cancel("page", changeset.changes.id, "")
            end,
            _input = text_input(
              f,
              :url,
              [
                class: "p-2 flex-grow-1 bd-highlight",
                style: "width: 100%"
              ]
            ),
            error = LiveViewWeb.ErrorHelpers.error_tag(f, :url),
            content_tag :div, [class: "p-2"] do
              InputHelpers.button_save(f, "")
            end,
            content_tag(:div, [class: "p-2"]) do
              InputHelpers.button_remove("page", changeset.changes.id, "")
            end,
            content_tag(:div, [ class: "p-2" ]) do
              Page.Dropdown.render(assigns, page)
            end,
            hidden_input(f, :id, value: f.params["id"]),
            hidden_input(f, :version_id, value: f.params["version_id"]),
            hidden_input(f, :storage_status, value: f.params["storage_status"]),
            hidden_input(f, :record_status, value: f.params["record_status"])
            || ""
          ]
        end
      else
        content_tag(:form, [ class: "d-flex" ] ) do
          [
            content_tag(:h4, [ class: "flex-grow-1 p-2" ]) do
              page.url
            end,
            content_tag(:div, [ class: "p-2" ]) do
              Page.Dropdown.render(assigns, page)
            end
            || ""
          ]
        end
      end
    end
  end
end
