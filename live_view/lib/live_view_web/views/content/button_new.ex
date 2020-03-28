defmodule LiveViewWeb.Content.Button.New do
  # use LiveViewWeb, :view
  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.Version
  alias LiveViewWeb.InputHelpers

  def render(assigns) do
    content_tag(:div, [class: "d-flex justify-content-around bd-highlight"]) do
      InputHelpers.button_new("content", assigns.current_team_id)
    end
  end
end
