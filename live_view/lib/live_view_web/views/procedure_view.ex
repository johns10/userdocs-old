defmodule LiveViewWeb.ProcedureView do
  use Phoenix.LiveView

  def render(procedure, assigns) do
    ~L"""
    <div class="">
      <div>
        <p>
          Name: <%= procedure %>
        </p>
        <p>
          <%= procedure %>
        </p>
      </div>
    </div>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, deploy_step: "Ready!")}
  end
end
