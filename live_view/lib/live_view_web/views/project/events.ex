defmodule LiveViewWeb.Project.Event do
  use Phoenix.LiveView

  require Logger

  alias LiveViewWeb.Project
  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Data
  alias LiveViewWeb.Changeset

  def handle_event("project::new", data, socket) do
    Logger.debug("It creates a new Project changeset, and puts it on the socket")
    assigns = Userdocs.Project.new(socket.assigns)
    { :noreply, assign(socket, assigns) }
  end

  def handle_event("project::edit", data, socket) do
    Logger.debug("It edits a project")
    project_id = Helpers.form_id(data)
    assigns = Userdocs.Project.edit(socket.assigns, project_id)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("project::save", %{"project" => project}, socket) do
    Logger.debug("It saves a project")
    project_id = Helpers.form_id(project)
    assigns = Userdocs.Project.save(socket.assigns, project)
    {:noreply, assign(socket, assigns) }
  end

  def handle_event("project::remove", data, socket) do
    Logger.debug("Removing Project")
    id = Helpers.form_id(data)
    assigns = Userdocs.Project.remove(socket.assigns, "project", id)
    {:noreply, assign(socket, assigns) }
  end

  def handle_event("project::cancel", data, socket) do
    Logger.debug("It cancels an edit on a project")
    id = Helpers.form_id(data)
    assigns = Userdocs.Project.cancel(socket.assigns, id)
    {:noreply, assign(socket, assigns) }
  end

  def handle_event("project::validate", %{"project" => project}, socket) do
    Logger.debug("Validating Project")
    project_id = Helpers.get_id(project["id"])
    assigns = Userdocs.Project.validate(socket.assigns, project, project_id)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("project::dropdown_toggle", data, socket) do
    assigns = Userdocs.Project.toggle_dropdown(socket.assigns)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("project::select", %{"id" => id}, socket) do
    id = Helpers.get_id(id)
    assigns = Userdocs.Project.select(socket.assigns, id)
    {:noreply, assign(socket, assigns)}
  end

  def handle_event("project::close_modal", data, socket) do
    assigns = Userdocs.Project.close_modal(socket.assigns)
    {:noreply, assign(socket, assigns)}
  end

end
