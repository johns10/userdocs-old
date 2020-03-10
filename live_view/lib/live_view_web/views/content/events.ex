defmodule LiveViewWeb.Content.Event do
  use Phoenix.LiveView

  require Logger

  alias LiveViewWeb.Content
  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Data
  alias LiveViewWeb.Changeset

  def handle_event("content::new", data, socket) do
    Logger.debug("It creates a new Content changeset, and puts it on the socket")
    assigns = Userdocs.Content.new(socket.assigns)
    { :noreply, assign(socket, assigns) }
  end

  def handle_event("content::save", %{"content" => content}, socket) do
    Logger.debug("It saves a project")
    id = Helpers.form_id(content)
    assigns = Userdocs.Content.save(socket.assigns, content)
    {:noreply, assign(socket, assigns) }
  end

  def handle_event("content::validate", %{"content" => object}, socket) do
    Logger.debug("Validating Project")
    id = Helpers.get_id(object["id"])
    assigns = Userdocs.Content.validate(socket.assigns, object, id)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("content::remove", data, socket) do
    Logger.debug("Removing Project")
    id = Helpers.form_id(data)
    assigns = Userdocs.Content.remove(socket.assigns, "content", id)
    {:noreply, assign(socket, assigns) }
  end

  def handle_event("content::cancel", data, socket) do
    Logger.debug("It cancels an edit on a project")
    id = Helpers.form_id(data)
    assigns = Userdocs.Content.cancel(socket.assigns, id)
    {:noreply, assign(socket, assigns) }
  end

  def handle_event("content::expand", data, socket)  do
    Logger.debug("It expands or un-expands the content")
    step_id = Helpers.get_id(data["id"])
    assigns = Userdocs.Content.expand(socket.assigns, step_id)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("content::menu_toggle", data, socket) do
    assigns = Userdocs.Content.menu_toggle(socket.assigns)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("content::close_modal", data, socket) do
    assigns = Userdocs.Content.close_modal(socket.assigns)
    {:noreply, assign(socket, assigns)}
  end
end
