defmodule LiveViewWeb.Content.Menu.Toggle do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Types

  alias LiveViewWeb.Project

  def render(assigns) do
    content_tag(:button,[
      type: "button",
      phx_click: "content::menu_toggle",
      class: "btn btn-primary"
    ]) do
      "Content"
    end
  end
end
