defmodule LiveViewWeb.Version.Form do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.ErrorHelpers
  alias LiveViewWeb.InputHelpers
  alias LiveViewWeb.Helpers

  def render(assigns, version_changeset, project) do
    ~L"""
    <div
      class="modal fade show"
      id="exampleModal"
      tabindex="-1"
      role="dialog"
      aria-labelledby="exampleModalLabel"
      aria-hidden="true"
      style="display: block; padding-right: 17px"
    >
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">Version</h5>
            <button
              type="button"
              class="close"
              data-dismiss="modal"
              aria-label="Close"
              phx-click="version::close_modal">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <%= f = form_for(version_changeset, "#",
            [ phx_submit: :"version::save", phx_change: :"version::validate" ]) %>
          <div class="modal-body">

              <%= hidden_input f, :id, value: f.params["id"] %>
              <%= hidden_input f, :storage_status, value: f.params["storage_status"] %>
              <%= hidden_input f, :record_status, value: f.params["record_status"] %>
              <%= hidden_input f, :project_id, value: f.params["project_id"] %>

              Record Status
              <%= f.params["record_status"] %></br>

              <label>Version Name</label>
              <%=
                InputHelpers.input f, :name,
                using: :text_input,
                value: f.params["name"],
                id: "version-name-text-input",
                placeholder: "1.0"
              %>
              <label>
          </div>
          <div class="modal-footer">
            <%= InputHelpers.button_save(f) %>
            <%= InputHelpers.button_remove("version",
              version_changeset.changes.id) %>
            <%= InputHelpers.button_cancel("version",
              version_changeset.changes.id) %>
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
