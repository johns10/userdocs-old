defmodule LiveViewWeb.PageView do
  #use LiveViewWeb, :view
  use Phoenix.LiveView
  alias LiveViewWeb.Helpers

  def render({ key, page }, assigns) do
    ~L"""
    <li>
      <a class="uk-accordion-title" href="#"><%= page.url %></a>
      <div class="uk-accordion-content">
        <%=
          LiveViewWeb.ProcedureView.render(
            Enum.at(Helpers.get(:procedure, [ page.procedure ]), 0),
            assigns)
        %>
      </div>
      <div class="uk-accordion-content">
        <%=
          LiveViewWeb.AnnotationsView.render(
            Enum.at(Helpers.get(:annotation, [ page.annotations ]), 0),
            assigns)
        %>
      </div>
    </li>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, deploy_step: "Ready!")}
  end

end
