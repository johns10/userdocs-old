defmodule LiveViewWeb.Element.Body do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.Element
  alias LiveViewWeb.InputHelpers

  def render(assigns, changeset, element) do
    content_tag(:p, [ class: "mb-1"]) do
      Element.Form.render(assigns, changeset, element)
    end
  end
end
