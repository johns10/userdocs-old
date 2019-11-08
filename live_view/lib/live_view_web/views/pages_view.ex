defmodule LiveViewWeb.PagesView do
  #use LiveViewWeb, :view
  use Phoenix.LiveView
  alias LiveViewWeb.Helpers

  def render(assigns) do
    ~L"""
    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="utf-8">
        <title>Demo</title>
        <link rel="stylesheet" href="node_modules/uikit/dist/css/uikit.min.css">
      </head>
      <body>
        <ul uk-accordion>
          <%= for page <- Helpers.get(:page, []) do %>
            <%= LiveViewWeb.PageView.render(page, assigns) %>
          <% end %>
        </ul>
      </body>
    </html>
    <div class="">
    </div>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, deploy_step: "Ready!")}
  end

end
