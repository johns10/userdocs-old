defmodule LiveViewWeb.AnnotationView do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Types

  def render(assigns) do
    ~L"""
    Hello
    """
  end

  def render(step, assigns, :header_only) do
    ~L"""
    <li class="list-group-item">
      <%= render(step, assigns, :header) %>
    </li>
    """
  end

  def render(assigns, annotation, :header_form) do
    ~L"""
    <li class="list-group-item">
      <%= render(assigns, annotation, :header) %>
      <%= render(assigns, annotation, :form) %>
    </li>
    """
  end

  def render(assigns, annotation, :header) do
    ~L"""
    <div
      href="#"
      phx-click="page_annotation_expand"
      phx-value-id=<%= annotation.id %>
    >
      <nav
        class="navbar bg-light"
        style="margin-top: -12px; margin-bottom: -12px; margin-left: -20px; margin-right: -20px"
      >
        <div class="d-flex justify-content-start">
          <%= annotation.name %>:
          <%= Enum.find(@annotation_type, nil, fn (o) -> o.id == annotation.annotation_type_id end) |> Map.get(:name) %>
        </div>
        <div class="d-flex justify-content-end">
          <button
            type="button"
            class="btn btn-secondary"
            phx-click="page_annotation_toggle_editable"
            phx-value-id=<%= annotation.id %>
          >
            <i class="fa fa-edit"></i>
          </button>
        </div>
      </nav>
    </div>
    """
  end

  def render(assigns, annotation, :form) do
    ~L"""
    <%= f = form_for(annotation.changeset, "annotation",
      [ phx_submit: :annotation_update, phx_change: :"annotation::validate" ]
    ) %>
      <%= hidden_input f, :id, value: annotation.id %>
      <%= hidden_input f, :annotation_type_id, value: annotation.annotation_type_id %>

      </br>
      <label>Name</label>
      <%= text_input f, :name, class: "form-control", value: annotation.name %>
      <label>Label</label>
      <%= text_input f, :label, class: "form-control", value: annotation.label %>
      <label>Description</label>
      <%= text_input f, :description, class: "form-control", value: annotation.description %>
      <label>Step Type</label>
      <%=
        select f, :annotation_type_id,
        Helpers.select(assigns, :annotation_type),
        value: annotation.annotation_type_id,
        class: "form-control"
      %>
      <hr/>
      <%= for step <- Helpers.children(assigns, :annotation_id, annotation, :step) do %>
        <%= inputs_for f, String.to_atom("step-" <> Integer.to_string(step.id)), fn s -> %>
          <div class="form-group">
            <%= hidden_input s, :id, value: step.id %>
            <%= hidden_input s, :storage_status, value: step.storage_status %>
            <%= hidden_input s, :version_id, value: step.version_id %>
            <%= hidden_input s, :annotation_id, value: step.annotation_id %>
            <%= hidden_input s, :page_id, value: step.page_id %>
            <%= hidden_input s, :order, value: step.order %>

            <label>
              Step Type
            </label>
            <%=
              select s, :step_type_id,
              Helpers.select(assigns, :step_type),
              value: step.step_type_id,
              class: "form-control"
            %>
            <div class="form-group">
              <%= for { key, value } <- step.args do %>
                <%= LiveViewWeb.Arg.render(key, value, f, step, assigns) %>
                </hr>
              <% end %>
            </div>
          </div>
        <% end %>
      <% end %>
      <%= if annotation.id in assigns.ui["project-steps-menu"]["editable"] do %>
        <div class="d-flex flex-row-reverse bd-highlight mb-3">
          <div class="p-2 bd-highlight">
            <%=
              submit "Save",
              class: "btn btn-success"
            %>
          </div>
          <div class="p-2 bd-highlight">
            <button
              type="button"
              class="btn btn-danger"
              phx-click="update_ui"
              phx-value-ui-id="project-steps-menu"
              phx-value-ui-element="new-step-menu"
              phx-value-ui-value="false">
              Cancel
            </button>
          </div>
        </div>
      <%= end %>
    </form>
    """
  end

  def render(:view, {id, annotation}, assigns) do
    ~L"""
    <%= if annotation.active == true do %>
      <li class="uk-list uk-list-line"
      href="#"
      phx-click="active_element"
      phx-value-id="<%= id %>"
      phx-value-type="<%= annotation.type %>"
      >
        <%= annotation.title %> <%= annotation.active %>
        <div uk-grid>
          <div class="uk-width-1-2@s">
            <% annotation.annotation_type %>
          </div>
          <div class="uk-width-1-1">
            <%= annotation.description %></br>
          </div>
        </div>
      </li>
    <% else %>
      <li class="uk-list uk-list-line"
      href="#"
      phx-click="active_element"
      phx-value-id="<%= id %>"
      phx-value-type="<%= annotation.type %>"
      >
      <%= annotation.title %>: <%= annotation.active %>
      </a>
    <% end %>
    """
  end


  def render(:form, parent_type, parent_id, {key, annotation}, assigns) do
    ~L"""
    <li class="uk-list uk-list-line uk-grid">
      <%= f = form_for @annotation_form_changeset, "#", [ phx_submit: :save_annotation, phx_change: :validate_annotation ] %>
        <div class="uk-grid-small" uk-grid>
          <%= hidden_input f, :parent_type, value: parent_type %>
          <%= hidden_input f, :parent_id, value: parent_id %>
          <%= hidden_input f, :type, value: :annotation %>
          <div class="uk-width-1-3@s">
            <div class="uk-margin uk-form-controls">
              <%= text_input f, :label, placeholder: "Label", value: "Label" %>
            </div>
          </div>
          <div class="uk-width-1-3@s">
            <div class="uk-margin uk-form-controls">
              <%= select f, :strategy, ["Xpath": "xpath", "ID": "id"] %>
            </div>
          </div>
          <div class="uk-width-1-3@s">
            <div class="uk-margin uk-form-controls">
              <%= select f, :annotation_type, select_annotation_types(assigns), value: :default %>
            </div>
          </div>
          <div class="uk-width-1-1">
            <div class="uk-margin uk-form-controls">
              <%= text_input f, :selector, placeholder: "Selector", value: "Selector", id: "userdocs-selector-form-field" %>
            </div>
          </div>
          <div class="uk-width-1-2@s">
            <div class="uk-margin uk-form-controls">
              <%= text_input f, :title, placeholder: "Title", value: "Title" %>
            </div>
          </div>
          <div class="uk-width-1-2@s">
            <div class="uk-margin uk-form-controls">
              <%= text_input f, :id, placeholder: "ID", value: UUID.uuid4() %>
            </div>
          </div>
          <div class="uk-width-1-1">
            <div class="uk-margin uk-form-controls">
              <%= text_input f, :description, placeholder: "Description", value: "Description" %>
            </div>
          </div>
          <div>
            <%= submit "Save" %>
          </div>
          <div class="uk-width-1-2@s">
            <button class="uk-button uk-button-default">Cancel</button>
          </div>
        </div>
      </form>
    </li>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, deploy_step: "Ready!")}
  end

  def select_annotation_types(assigns) do
    State.get(:annotation_type, [])
    |> Enum.map( fn{ key, annotation_type } ->
        { String.capitalize(Atom.to_string(key)), key }
      end)
  end

end
