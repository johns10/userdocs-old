defmodule LiveViewWeb.Steps.Header do
  # use LiveViewWeb, :view
  use Phoenix.LiveView
  use Phoenix.HTML

  require Logger

  def render(assigns, parent_type, parent_id) do
    content_tag(:div, [
      class: "card-header",
      phx_click: parent_type <> "::step_list_expand",
      phx_value_id: parent_id
    ]) do
      "Steps"
    end
  end

end
