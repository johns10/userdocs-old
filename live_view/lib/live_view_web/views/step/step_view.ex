defmodule LiveViewWeb.StepView do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Types
  alias LiveViewWeb.InputHelpers

  def render(changeset, step, assigns, :empty_header_form) do
    ~L"""
    <%= render(changeset, assigns, :empty_header) %>
    <%= render(changeset, step, assigns, :form) %>
    """
  end

  def render(step, assigns, parent_type, parent_id, :header_only, action) do
    ~L"""
    <%= LiveViewWeb.Step.Header.render(step, assigns, action, parent_type, parent_id) %>
    """
  end

  def render(step, assigns, :header_form, action, parent_type, parent_id) do
    render(%{ id: nil }, step, assigns, :header_form, action, parent_type, parent_id)
  end

  def render(changeset, step, assigns, :header_form, action, parent_type, parent_id) do
    ~L"""
    <%= LiveViewWeb.Step.Header.render(step, assigns, action, parent_type, parent_id) %>
    <%= render(changeset, step, assigns, :form) %>
    """
  end

  def render(changeset, assigns, :empty_header) do
    ~L"""
    <div>
      <nav
        class="navbar bg-light"
        style="margin-top: -12px; margin-bottom: -12px; margin-left: -20px; margin-right: -20px"
      >
        <div class="d-flex justify-content-start">
          <%= changeset.changes.order %>:
          <%=
            Enum.find(
              @step_type,
              nil,
              fn (o) ->
                o.id == changeset.changes.step_type_id end
              )
            |> Map.get(:name)
          %>
          <%= changeset.params["storage_status"]  %>
          <%= changeset.params["record_status"]  %>
        </div>
      </nav>
    </div>
    """
  end

  def render(step_changeset, step, assigns, :form) do
    ~L"""
    <%=
      f = form_for(step_changeset, "#",
      [ phx_submit: :"step::save", phx_change: :"step::validate" ])
    %>
      <%= hidden_input f, :id, value: f.params["id"] %>
      <%= hidden_input f, :storage_status, value: f.params["storage_status"] %>
      <%= hidden_input f, :record_status, value: f.params["record_status"] %>
      <%= hidden_input f, :version_id, value: f.params["version_id"] %>
      <%= hidden_input f, :annotation_id, value: f.params["annotation_id"] %>
      <%= hidden_input f, :page_id, value: f.params["page_id"] %>
      <%= hidden_input f, :order, value: f.params["order"] %>

      </br>
      <label>
        Step Type
      </label>
      <%=
        select f, :step_type_id,
        Helpers.select(assigns, :step_type),
        value: f.params["step_type_id"],
        class: "form-control"
      %>
      <div class="form-group">
        <%= inputs_for f, :args, fn fp -> %>
          <%= IO.puts("Rendering args form")
            step_id = try do
              Integer.to_string(Helpers.get_id(f.params["id"]))
            rescue
              e in ArgumentError -> "new"
            end
            LiveViewWeb.ArgView.render(
              fp.params["key"],
              fp.params["value"],
              fp,
              step_id,
              assigns)
          %>
        <% end %>
      </div>
      <div class="modal-footer">
        <%= InputHelpers.button_save(f) %>
        <%= InputHelpers.button_remove("step",
          step_changeset.changes.id) %>
        <%= InputHelpers.button_cancel("step",
          step_changeset.changes.id) %>
      </div>
    """
  end

  def render(parent_type, parent_id, assigns, :new_step_button) do
    content_tag(:div, [ class: "d-flex justify-content-around bd-highlight" ]) do
      content_tag(:div, [ class: "p-2 bd-highlight" ]) do
        InputHelpers.button_new("step", parent_id, parent_type,
            LiveViewWeb.Version.current(assigns) == nil)
      end
    end
  end
end
