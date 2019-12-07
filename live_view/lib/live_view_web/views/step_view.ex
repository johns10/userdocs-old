defmodule LiveViewWeb.StepView do
  use Phoenix.LiveView

  def render({ id, step }, assigns) do
    ~L"""
    <%= if step.active == true do %>
      <li class="uk-list uk-list-line"
      href="#"
      phx-click="active_element"
      phx-value-id="<%= id %>"
      phx-value-type="<%= step.type %>"
      >
        <%= id %> <%= step.active %>
      </li>
      <div uk-grid>
        <div class="uk-width-1-2">
          <%= step.step_type %>
        </div>
        <div class="uk-width-1-2">
          <% step.strategy %>
        </div>
        <div class="uk-width-1-1">
          <%= for { key, value } <- step.args do %>
            <%= key %></br><%= value %>
          <%= end %>
        </div>
      </div>
    <%= else %>
      <li class="uk-list uk-list-line"
      href="#"
      phx-click="active_element"
      phx-value-id="<%= id %>"
      phx-value-type="<%= step.type %>"
      >
        <%= id %> <%= step.active %></a>
      </li>
    <%= end %>

    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, deploy_step: "Ready!")}
  end
end
