defmodule LiveViewWeb.Project.Menu do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Types

  alias LiveViewWeb.Project

  def render(assigns) do
    current_project = Project.current(assigns)
    project_changesets = assigns.changesets["project"]
    ~L"""
    <div>
      <div class="btn-group" role="group" aria-label="Basic example">
        <button
          type="button"
          class="btn btn-secondary"
          phx-click="project::edit"
          phx-value-id=<%= @current_project_id %>
        >
          <i class="fa fa-edit"></i>
        </button>
        <button
          class="btn btn-secondary dropdown-toggle"
          type="button"
          data-toggle="dropdown"
          aria-haspopup="true"
          <%= if @ui.project_menu.toggled do %>
            aria-expanded="true"
          <%= else %>
            aria-expanded="false"
          <%= end %>
          phx-click="project::dropdown_toggle"
        >
          <%= current_project.name %>
        </button>
      </div>
      <%= if @ui.project_menu.toggled do %>
        <div class="dropdown-menu show" aria-labelledby="dropdownMenuButton">
      <%= else %>
        <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
      <%= end %>
        <%= for project <- Enum.filter(@project, fn(p) -> (p.record_status != "removed") || (assigns.show_removed_projects == true) end) do %>
          <a
            class="dropdown-item"
            href="#"
            phx-click="project::select"
            phx-value-id=<%= project.id %>
          >
            <%= project.name %>
          </a>
        <%= end %>
        <a
          class="dropdown-item"
          href="#"
          phx-click="project::new"
        >
          <i class="fa fa-plus"></i>  New Project
        </a>
      </div>
    </div>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, deploy_step: "Ready!")}
  end
end
