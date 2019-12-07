defmodule LiveViewWeb.Annotation do
  use Phoenix.LiveView
  use Phoenix.HTML

  def render(assigns) do
    ~L"""
    Hello
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
            <%= annotation.strategy %>
          </div>
          <div class="uk-width-1-2@s">
            <% annotation.annotation_type %>
          </div>
          <div class="uk-width-1-1">
            <%= annotation.selector %></br>
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
              <%= text_input f, :selector, placeholder: "Selector", value: "Selector" %>
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
