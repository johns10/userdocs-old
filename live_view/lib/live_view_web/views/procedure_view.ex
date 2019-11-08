defmodule LiveViewWeb.ProcedureView do
  use Phoenix.LiveView
  alias LiveViewWeb.Helpers

  def render({ key, procedure }, assigns) do
    ~L"""
    <p>
      Name: <%= procedure.name %>
    </p>
    <%= LiveViewWeb.StepsView.render(
      Helpers.get(:step, procedure.steps), assigns
      )
    %>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, deploy_step: "Ready!")}
  end
end
