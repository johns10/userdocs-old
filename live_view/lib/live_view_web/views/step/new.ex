defmodule LiveViewWeb.Step.Control.New do
  # use LiveViewWeb, :view
  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.Version
  alias LiveViewWeb.InputHelpers

  def render(assigns, parent_id) do
    content_tag(:div, [class: "d-flex justify-content-around bd-highlight"]) do
      InputHelpers.button_new("step", parent_id)
    end
  end
end
