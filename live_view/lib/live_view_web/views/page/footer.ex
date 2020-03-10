defmodule LiveViewWeb.Page.Footer do
  # use LiveViewWeb, :view
  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.Version
  alias LiveViewWeb.InputHelpers

  require Logger

  def render(assigns, parent_id) do
    "Stuff"
  end

  def mount(session, socket) do
    {:ok, assign(socket, deploy_step: "Ready!")}
  end

end
