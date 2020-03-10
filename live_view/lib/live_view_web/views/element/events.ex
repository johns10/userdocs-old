defmodule LiveViewWeb.Element.Event do
  use Phoenix.LiveView

  require Logger

  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Version
  alias LiveViewWeb.Page
  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Data
  alias LiveViewWeb.Changeset

  def handle_event("element::expand", data, socket) do
    id = Helpers.get_id(data["id"])
    assigns = Userdocs.Element.expand(socket.assigns, id)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("element::new", data, socket) do
    Logger.debug("It creates a new changeset for this page and puts on state")
    page_id = Helpers.get_id(data["id"])
    assigns = Userdocs.Element.new(socket.assigns, page_id)
    {:noreply, assign(socket, assigns)}
  end


  def handle_event("element::edit", data, socket) do
    Logger.debug("It creates a changeset for the element, and puts it on the socket")
    page_id = Helpers.get_id(data["id"])
    assigns = Userdocs.Element.edit(socket.assigns, page_id)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("element::save", %{"element" => element}, socket) do
    Logger.debug("It saves this element to the state:")
    assigns = Userdocs.Element.save(socket.assigns, element)
    {:noreply, assign(socket, assigns)}
  end
  def handle_event("element::remove", data, socket) do
    Logger.debug("Removing element")
    id = Helpers.form_id(data)
    assigns = Userdocs.Element.remove(socket.assigns, :element, id)
    {:noreply, assign(socket, assigns)}
  end
  def handle_event("element::cancel", data, socket) do
    Logger.debug("It cancels an element form")
    id = Helpers.form_id(data)
    assigns = Userdocs.Element.cancel(socket.assigns, id)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("element::validate", %{"element" => element}, socket) do
    Logger.debug("Validating element")
    id = Helpers.get_id(element["id"])
    assigns = Userdocs.Element.validate(socket.assigns, element)
    {:noreply, assign(socket, assigns)}
  end
  """
  def handle_event("page::expand", data, socket) do
    id = Helpers.get_id(data["id"])
    assigns = Userdocs.Page.expand(socket.assigns, id)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("page::select", data = %{"id" => id}, socket) do
    socket =
      Page.set_current(socket, id)
      |> Helpers.put_in_socket([:ui, "page-menu", "toggled"], false)

    {:noreply, socket}
  end

  def handle_event("page::close_modal", data, socket) do
    socket = Helpers.put_in_socket(socket, [:ui, :version_page_menu, :toggled], false)
    {:noreply, socket}
  end

  def handle_event("page::dropdown_toggle", data, socket) do
    id = Helpers.get_id(data["id"])
    assigns = Userdocs.Page.toggle_dropdown(socket.assigns, id)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("page::step_list_expand", data, socket) do
    Logger.debug("Expanding Page Step List")
    id = Helpers.get_id(data["id"])
    assigns = Userdocs.Page.expand_step_list(socket.assigns, id)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("page::element_list_expand", data, socket) do
    Logger.debug("Expanding Page Step List")
    id = Helpers.get_id(data["id"])
    assigns = Userdocs.Page.expand_element_list(socket.assigns, id)
    {:noreply, assign(socket, assigns)}
  end
"""
end
