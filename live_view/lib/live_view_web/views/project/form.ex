defmodule LiveViewWeb.Project.Form do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.ErrorHelpers
  alias LiveViewWeb.InputHelpers
  alias LiveViewWeb.Helpers

  def render(assigns, project_changeset) do
    ~L"""
    <div
      class="modal fade show"
      id="versionModal"
      tabindex="-1"
      role="dialog"
      aria-labelledby="VersionModalLabel"
      aria-hidden="true"
      style="display: block; padding-right: 17px"
    >
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="VersionModalLabel">Project</h5>
            <button
              type="button"
              class="close"
              data-dismiss="modal"
              aria-label="Close"
              phx-click="project::close_modal">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <%=
            f = form_for( project_changeset, "#",
              [ phx_submit: :"project::save", phx_change: :"project::validate" ]) %>
          <div class="modal-body">

              <%= hidden_input f, :team_id, value: f.params["team_id"] %>
              <%= hidden_input f, :id, value: f.params["id"] %>
              <%= hidden_input f, :storage_status, value: f.params["storage_status"] %>
              <%= hidden_input f, :record_status, value: f.params["record_status"] %>

              Record Status
              <%= f.params["record_status"] %></br>

              <%=
                InputHelpers.input f, :name,
                using: :text_input,
                value: f.params["name"],
                id: "project-name-text-input",
                placeholder: "Google"
              %>
              <%=
                InputHelpers.input f, :base_url,
                using: :text_input,
                value: f.params["base_url"],
                id: "project-base-url-text-input",
                placeholder: "www.google.com"
              %>
              <%=
                InputHelpers.input f, :project_type,
                using: :text_input,
                value: f.params["project_type"],
                id: "project-project-type-text-input",
                placeholder: "Web"
              %>
          </div>
          <div class="modal-footer">
            <%= InputHelpers.button_save(f) %>
            <%= InputHelpers.button_remove("project",
              project_changeset.params["id"]) %>
            <%= InputHelpers.button_cancel("project",
              project_changeset.params["id"]) %>
          </div>
        </div>
      </div>
    </div>
    """
  end



  def mount(_session, socket) do
    {:ok, assign(socket, deploy_step: "Ready!")}
  end
end
