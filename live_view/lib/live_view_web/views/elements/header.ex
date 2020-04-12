defmodule LiveViewWeb.Elements.Header do
  # use LiveViewWeb, :view
  use Phoenix.LiveView
  use Phoenix.HTML

  require Logger

  def render(assigns, page) do
    content_tag(:div, [
      class: "card-header",
      phx_click: "page::element_list_expand",
      phx_value_id: page.id
    ]) do
      "Elements"
    end
  end

end
