defmodule LiveViewWeb.Version.Event do
  use Phoenix.LiveView

  require Logger

  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Version
  alias LiveViewWeb.Project
  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Data
  alias LiveViewWeb.Changeset

  def handle_event("version::new", data, socket) do
    Logger.debug("It creates a new changeset for this version and puts on state")
    project_id = Helpers.get_id(data["project-id"])
    assigns = Userdocs.Version.new(socket.assigns, project_id)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("version::edit", data, socket) do
    Logger.debug("It creates a changeset for the version, and puts it on the socket")
    version_id = Helpers.get_id(data["version-id"])
    assigns = Userdocs.Version.edit(socket.assigns, version_id)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("version::save", %{"version" => version}, socket) do
    Logger.debug("It saves this version to the state:")
    assigns = Userdocs.Version.save(socket.assigns, version)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("version::remove", data, socket) do
    Logger.debug("Removing Version")
    id = Helpers.form_id(data)
    assigns = Userdocs.Version.remove(socket.assigns, :version, id)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("version::cancel", data, socket) do
    Logger.debug("It cancels an edit on a version")
    id = Helpers.form_id(data)
    assigns = Userdocs.Version.cancel(socket.assigns, id)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("version::validate", %{"version" => version}, socket) do
    Logger.debug("Validating Version")
    id = Helpers.get_id(version["id"])
    assigns = Userdocs.Version.validate(socket.assigns, version, id)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("version::toggle", data, socket) do
    assigns = Userdocs.Version.toggle_dropdown(socket.assigns)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("version::select", data = %{"id" => id}, socket) do
    id = Helpers.get_id(id)
    assigns = Userdocs.Version.select(socket.assigns, id)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("version::close_modal", data, socket) do
    assigns = Userdocs.Version.close_modal(socket.assigns)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("version::step_list_expand", data, socket) do
    Logger.debug("Expanding Version Step List")
    id = Helpers.get_id(data["id"])
    assigns = Userdocs.Version.expand_step_list(socket.assigns, id)
    {:noreply, assign(socket, assigns)}
  end
end
