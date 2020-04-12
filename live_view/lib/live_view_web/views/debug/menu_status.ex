defmodule LiveViewWeb.Debug.MenuStatus do
  require Logger

  use Phoenix.LiveView
  use Phoenix.HTML

  def render(assigns) do
    ~L"""
    <div class="container-fluid">
      <div class="row">
        <div class="col-4">
          Project Steps Menu Toggled: <%= assigns.ui.project_steps_menu.toggled %></br>
          Project Form Toggled: <%= assigns.ui.project_form.toggled %></br>
          Project Form Mode: <%= assigns.ui.project_form.mode %></br>
          Version Form Toggled: <%= assigns.ui.version_form.toggled %></br>
          Page Menu Status: <%= assigns.ui["page-menu"]["active"] %></br>
          Version Page Menu: <%= assigns.ui.version_page_control.mode %></br>
          New Version Page: <%= assigns.current_changesets.new_version_pages[assigns.current_version_id] %></br>
          Content Menu: <%= assigns.ui.content_menu.toggled %>
          Content Form Mode: <%= assigns.ui.content_form.mode  %>
        </div>
        <div class="col-4">
          Version Form Mode: <%= assigns.ui.version_form.mode %></br>
          Current Project: <%= assigns.current_project_id %></br>
          Project Status: <%= Map.get(Userdocs.Project.Constants.current(assigns), :storage_status) %></br>
          Current Version: <%= assigns.current_version_id %></br>
          Project Dropdown Toggled: <%= assigns.ui.project_menu.toggled %></br>
          Active Page: <%= assigns.ui.page_dropdown.active %></br>
          Version Page Mode: <%= assigns.ui.version_page_control.mode %></br>
          Current Team: <%= assigns.current_team_id %>
        </div>
        <div class="col-4">
          Version Dropdown Toggled: <%= assigns.ui.version_menu.toggled %></br>
          Active Annotations:
          <%=
            for object <- assigns.active_page_annotations do
              object
            end
          %></br>
          Active Pages: <%= for object <- assigns.active_pages do %>
          <%= object %>
          <% end %></br>
          Edit Pages: <%= for object <- assigns.page_edit do %>
          <%= object %>
          <% end %></br>
          Active Page Steps: <%= for object <- assigns.active_steps do %>
          <%= object %>
          <% end %></br>
          Active Page Elements: <%= for object <- assigns.active_page_elements do %>
          <%= object %>
          <% end %></br>
          Active Elements: <%= for object <- assigns.active_elements do %>
          <%= object %>
          <% end %></br>
          Active Versions: <%= for object <- assigns.active_version_steps do %>
          <%= object %>
          <% end %></br>
        </div>
      </div>
    </div>
    """
  end
end
