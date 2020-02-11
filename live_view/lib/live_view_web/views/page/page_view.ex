defmodule LiveViewWeb.PageView do
  # use LiveViewWeb, :view
  use Phoenix.LiveView

  alias LiveViewWeb.Types
  alias LiveViewWeb.Helpers
  alias Storage.AnnotationForm

  def render(assigns, page, :footer_menu) do
    ~L"""
    <div>
      <div class="card-body">
        <div class="d-flex justify-content-around bd-highlight">
          <div class="p-2 bd-highlight">
            <button
              type="button"
              class="btn btn-primary btn-lg btn-block"
              phx-click="page_annotation_new"
              phx-value-id=<%= page.id %>
              >
              <i class="fa fa-plus"></i>   Annotation
            </button>
          </div>
          <div class="p-2 bd-highlight">
            <button
              type="button"
              class="btn btn-success btn-block btn-lg"
              phx-click="step::new"
              phx-value-id=<%= page.id %>
              >
              <i class="fa fa-plus"></i>   Step
            </button>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def render(assigns, page, :header) do
    ~L"""
    <div
      class="card"
      href="#"
      phx-click="page_expand"
      phx-value-id="<%= page.id %>"
    >
      <div class="card-body">
        <div class="row">
          <h2 class="card-title col-11">
            <%= page.url %>
          </h2>
          <div class="col-1">
            <%= if Helpers.has_children(:page, page.id, @job) do %>
              <button
                href="#"
                type="button"
                class="btn btn-success"
                phx-click="annotate_page"
                phx-value-id="<%= page.id %>"
                phx-value-type="<%= :page %>"
              >
                <i class="fa fa-edit"></i>
              </button>
            <%= else %>
              <button
                href="#"
                type="button"
                class="btn btn-success"
                phx-click="annotate_page"
                phx-value-id="<%= page.id %>"
                phx-value-type="<%= :page %>"
              >
                <i class="fa fa-edit"></i>
              </button>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end


  def mount(session, socket) do
    {:ok, assign(socket, deploy_step: "Ready!")}
  end

end
