defmodule LiveViewWeb.Element.Header do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Types
  alias LiveViewWeb.InputHelpers

  require Logger

  def render(assigns, element) do
    Logger.debug("Rendering Element Header")
    [
      content_tag(:h5, [ class: "mb-1"]) do
        element.name
      end,
      Integer.to_string(element.id), ": ",
      element.storage_status, " ",
      element.record_status
      || ""
    ]
  end
end
