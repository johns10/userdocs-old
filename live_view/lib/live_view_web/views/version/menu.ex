defmodule LiveViewWeb.Version.Menu do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Types

  alias LiveViewWeb.Project
  alias LiveViewWeb.Version

  def render(assigns) do
    version = Version.current(assigns)
    version_changesets = assigns.changesets["version"]
    project = Project.current(assigns)
    project_changesets = assigns.changesets["project"]
    ~L"""
    <div>
      <div class="btn-group" role="group" aria-label="Basic example">
        <button
          type="button"
          class="btn btn-secondary"
          <%= if version != nil && version.id != nil do %>
            phx-click="version::edit"
            phx-value-project-id=<%= project.id %>
            phx-value-version-id=<%= version.id %>
          <%= else %>
            phx-value-project-id=<%= project.id %>
            phx-click="version::new"
          <% end %>
        >
          <i class="fa fa-edit"></i>
        </button>
        <button
          class="btn btn-secondary dropdown-toggle"
          type="button"
          data-toggle="dropdown"
          aria-haspopup="true"
          aria-expanded="false"
          phx-click='version::toggle'
        >
          <%= if version != nil && version.id != nil do %>
            <%= version.name %>
          <%= else %>
          <% end %>
        </button>
      </div>
      <%= if @ui.version_menu.toggled do %>
        <div class="dropdown-menu show" aria-labelledby="dropdownMenuButton">
      <%= else %>
        <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
      <%= end %>
        <%= for version <- Helpers.children(assigns, :project_id, Project.current(assigns), :version) do %>
          <a
            class="dropdown-item"
            href="#"
            phx-click="version::select"
            phx-value-id=<%= version.id %>
          >
            <%= version.name %>
          </a>
        <%= end %>
        <a
          class="dropdown-item"
          href="#"
          phx-click="version::new"
          phx-value-project-id=<%= project.id %>
        >
          <i class="fa fa-plus"></i>  New Version
        </a>
      </div>
    </div>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, deploy_step: "Ready!")}
  end
end
