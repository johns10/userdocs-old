defmodule LiveViewWeb.PageView do
  #use LiveViewWeb, :view
  use Phoenix.LiveView
  alias LiveViewWeb.Helpers

  def render({ key, page }, assigns) do
    ~L"""
    <div class="">
      <div>
        <p>
          URL: <%= page.url %> </br>
          Procedure: <%= page.procedure %>
        </p>
        <p>
          <%= LiveViewWeb.ProcedureView.render(Helpers.get(:procedure, [ page.procedure ]), assigns) %>
        </p>
      </div>
    </div>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, deploy_step: "Ready!")}
  end

end
