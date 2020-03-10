defmodule LiveViewWeb.Page.Dropdown do
  # use LiveViewWeb, :view
  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.Version
  alias LiveViewWeb.InputHelpers

  require Logger

  def render(assigns, page) do
    show =
      if assigns.ui.page_dropdown.active == page.id do
        " show"
      else
        ""
      end
    content_tag(:div, [ class: "dropdown" <> show ]) do
      [
        content_tag(:button, [
          href: "#",
          type: "button",
          class: "btn btn-success dropdown-toggle",
          id: "dropdownMenuButton",
          data_toggle: "dropdown",
          aria_haspopup: "true",
          aria_expanded: "false",
          phx_click: "page::dropdown_toggle",
          phx_value_id: page.id
        ]) do
          content_tag(:i, [ class: "fa fa-edit"]) do
            ""
          end
        end,
        content_tag(:h2, [
          class: "dropdown-menu" <> show,
          aria_labelledby: "dropdownMenuButton"
        ]) do
          content_tag(:a, [
            class: "dropdown-item",
            phx_click: "page::edit",
            phx_value_id: page.id,
            href: "#"
          ]) do
            "Edit"
          end
        end
      ]
    end
  end
end





