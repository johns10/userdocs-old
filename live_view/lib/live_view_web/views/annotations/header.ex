defmodule LiveViewWeb.Page.Annotations.Header do
  # use LiveViewWeb, :view
  use Phoenix.LiveView
  use Phoenix.HTML

  require Logger

  def render(parent_type, parent_id, assigns) do
    content_tag(:div, [
      class: "card-header",
      phx_click: Atom.to_string(parent_type) <> "::annotation_list_expand",
      phx_value_id: parent_id
    ]) do
      "Annotations"
    end
  end

end
