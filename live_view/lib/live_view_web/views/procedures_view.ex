defmodule LiveViewWeb.ProceduresView do
  #use LiveViewWeb, :view
  use Phoenix.LiveView
  alias LiveViewWeb.Helpers

  def render({ key, object }, assigns) do
    ~L"""
    <div class="">
      <div>
        <p>
          <%= for procedure <- Helpers.get(:procedure, key) do %>
            Procedure
            <%= LiveViewWeb.Procedure.render(procedure, assigns) %>
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
