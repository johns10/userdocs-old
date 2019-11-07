defmodule LiveViewWeb.PagesView do
  #use LiveViewWeb, :view
  use Phoenix.LiveView
  alias LiveViewWeb.Helpers

  def render(assigns) do
    ~L"""
    <div class="">
      <div>
        <p>
          <%= for page <- Helpers.get(:page, []) do %>
            <%= LiveViewWeb.PageView.render(page, assigns) %>
          <% end %>
        </p>
      </div>
    </div>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, deploy_step: "Ready!")}
  end

end
