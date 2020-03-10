defmodule LiveViewWeb.Content.Header do
  require Logger

  use Phoenix.LiveView
  use Phoenix.HTML


  def render(content, assigns) do
    content_tag(:div, [
      class: "d-flex w-100 justify-content-between",
      href: "#",
      phx_click: "content::expand",
      phx_value_id: content.id
    ]) do
      [
        content_tag(:h5, [ class: "mb-1" ]) do
          content.name
        end,
        " (", Integer.to_string(content.id), "): ",
        content.storage_status, " ",
        content.record_status
      ]
    end
  end
end
