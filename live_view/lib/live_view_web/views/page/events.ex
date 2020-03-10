defmodule LiveViewWeb.Page.Event do
  use Phoenix.LiveView

  require Logger

  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Version
  alias LiveViewWeb.Page
  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Data
  alias LiveViewWeb.Changeset

  def handle_event("page::new", data, socket) do
    Logger.debug("It creates a new changeset for this page and puts on state")
    version_id = Helpers.get_id(data["id"])
    assigns = Userdocs.Page.new(socket.assigns, version_id)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("page::edit", data, socket) do
    Logger.debug("It creates a changeset for the page, and puts it on the socket")
    page_id = Helpers.get_id(data["id"])
    assigns = Userdocs.Page.edit(socket.assigns, page_id)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("page::save", %{"page" => page}, socket) do
    Logger.debug("It saves this page to the state:")
    assigns = Userdocs.Page.save(socket.assigns, page)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("page::remove", data, socket) do
    Logger.debug("Removing page")
    id = Helpers.form_id(data)
    assigns = Userdocs.Page.remove(socket.assigns, :page, id)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("page::cancel", data, socket) do
    Logger.debug("It cancels an edit on a page")
    id = Helpers.form_id(data)
    assigns = Userdocs.Page.cancel(socket.assigns, id)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("page::validate", %{"page" => page}, socket) do
    Logger.debug("Validating page")
    id = Helpers.get_id(page["id"])
    assigns = Userdocs.Page.validate(socket.assigns, page, id)
    {:noreply, assign(socket, assigns)}
  end

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

  def handle_event("page::annotation_list_expand", data, socket) do
    Logger.debug("Expanding Page Step List")
    id = Helpers.get_id(data["id"])
    assigns = Userdocs.Page.expand_annotation_list(socket.assigns, id)
    {:noreply, assign(socket, assigns)}
  end

end
