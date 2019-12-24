defmodule LiveViewWeb.PagesView do
  #use LiveViewWeb, :view
  use Phoenix.LiveView

  alias LiveViewWeb.Helpers
  alias Storage.AnnotationForm

  def render(assigns) do
    ~L"""
    <!DOCTYPE html>

    <html>
      <head>
        <meta charset="utf-8">
        <title>Demo</title>
      </head>
      <%= for { id, project } <- @project do %>
        <div class="jumbotron jumbotron-fluid">
          <div class="mx-auto" style="width: 100%;">
            <h1><%= project.title %></h1>
          </div>
          <div class="container-fluid">
            <%= for step <- Helpers.children(:project, id, :step, @step) do %>
              <%= LiveViewWeb.StepView.render(step, assigns) %>
            <% end %>
            <%= for { id, page } <- Helpers.children(:project, id, :page, @page) do %>
              <div class="uk-flex-inline">
                <a
                  href="#"
                  phx-click="active_element"
                  phx-value-id="<%= id %>"
                  phx-value-type="<%= page.type %>"
                  class="uk-align-left"
                >
                  <h3>
                    <%= page.url %>
                  </h3>
                </a>
                <%= if Helpers.has_children(:page, id, @job) do %>
                <button
                  href="#"
                  phx-click="annotate_page"
                  phx-value-id="<%= id %>"
                  phx-value-type="<%= page.type %>"
                  class="uk-button-small uk-align-right"
                >
                  Annotate
                </button>
                <%= else %>
                  <button
                    href="#"
                    phx-click="annotate_page"
                    phx-value-id="<%= id %>"
                    phx-value-type="<%= page.type %>"
                    class="uk-button-small uk-align-right"
                  >
                    Annotate
                  </button>
                <%= end %>
                <%= for { id, job } <- Helpers.children(:page, id, :job, @job) do %>
                  <%= job.status %>
                <% end %>
              </div>
              <%= if page.active == true do %>
                <div>
                  <ul>
                    <%= for step <- Helpers.children(:page, id, :step, @step) do %>
                      <%= LiveViewWeb.StepView.render(step, assigns) %>
                    <% end %>
                  </ul>
                </div>
                <hr class="uk-divider-icon">
                <div>
                  <ul>
                    <%= for annotation <- Helpers.children(:page, id, :annotation, @annotation) do %>
                      <%= LiveViewWeb.Annotation.render(:view, annotation, assigns) %>
                    <% end %>
                  </ul>
                </div>
                <div>
                  <%= if @new_annotation == false do %>
                    <button
                      class="uk-button uk-button-primary uk-width-1-1"
                      uk-icon="plus"
                      phx-click="hello"
                      >
                    </button>
                  <% else %>
                    <%= LiveViewWeb.Annotation.render(
                      :form,
                      page.type,
                      id,
                      { "test", %Storage.AnnotationForm{ } },
                      assigns
                    ) %>
                  <% end %>
                </div>
              <% end %>
            <% end %>
          </div>
        <% end %>
      </div>
    </html>
    """
  end

  def mount(_session, socket) do
    :pg2.join(:live_state, self())

    # UI Data
    socket = assign(socket, new_annotation: false)
    # Application Data Slots
    socket = assign(socket, project: %{})
    socket = assign(socket, page: %{})
    socket = assign(socket, step: %{})
    socket = assign(socket, annotation: %{})
    socket = assign(socket, job: %{})
    # Application Data
    socket = Helpers.get(socket, :project, [:test])
    socket = Helpers.get_all_related_data(socket, :project, Map.keys(socket.assigns.project), :page)
    socket = Helpers.get_all_related_data(socket, :project, Map.keys(socket.assigns.project), :step)
    socket = Helpers.get_all_related_data(socket, :project, Map.keys(socket.assigns.project), :job)
    #socket = Helpers.get(socket, :page, [])
    socket = Helpers.get(socket, :annotation_type, [])
    socket = Helpers.get_all_related_data(socket, :page, Map.keys(socket.assigns.page), :step)
    socket = Helpers.get_all_related_data(socket, :page, Map.keys(socket.assigns.page), :job)
    socket = Helpers.get_all_related_data(socket, :page, Map.keys(socket.assigns.page), :annotation)
    socket = Helpers.get_all_related_data(socket, :annotation, Map.keys(socket.assigns.annotation), :step)

    # Add properties for UI controls
    socket = Helpers.add_property(socket, :page, :active, false)
    socket = Helpers.add_property(socket, :annotation, :active, false)
    socket = Helpers.add_property(socket, :step, :active, false)

    # Add injections for future updates
    socket = assign(socket, :injections, %{})

    socket = Helpers.configure_injection(socket, :page)
    socket = Helpers.configure_injection(socket, :annotation)
    socket = Helpers.configure_injection(socket, :step)
    socket = Helpers.configure_injection(socket, :job)

    socket = Helpers.add_injection(socket, :page, :active, false)
    socket = Helpers.add_injection(socket, :annotation, :active, false)
    socket = Helpers.add_injection(socket, :step, :active, false)
    socket = Helpers.add_injection(socket, :step, :job, false)

    # Add subscriptions
    Phoenix.PubSub.subscribe(:live_state, "annotation")
    Phoenix.PubSub.subscribe(:live_state, "job")

    # Add changesets
    socket = assign(
      socket,
      :annotation_form_changeset,
      AnnotationForm.changeset(
        %AnnotationForm{},
        %{},
        %{
          pages: socket.assigns.page,
          annotation_types: socket.assigns.annotation_type
        }
      )
    )
    { :ok, socket }
  end

  def handle_info({ type, command, id, object }, socket) do
    {
      :noreply,
      assign(
        socket,
        Subscription.Handler.handle(
          type, command, id, object, socket.assigns
        )
      )
    }
  end

  def handle_event("active_element", %{ "id" => id, "type" => type }, socket) do
    #IO.puts("Activating element #{type}: #{id}")
    { :ok, _assigns } = Map.fetch(socket, :assigns)
    id = String.to_atom(id)
    type = String.to_atom(type)
    objects = Enum.map(socket.assigns[type],
      fn { key, object } ->
        { key, Map.put(object, :active, false)}
      end)
    |> Enum.into(%{})
    |> Kernel.put_in( [id, :active], not socket.assigns[type][id].active)
    { :noreply, assign(socket, type, objects) }
  end

  def handle_event("validate_annotation", %{"annotation_form" => annotation}, socket) do
    #IO.puts("Validating")
    pages = socket.assigns.page
    annotation_types = socket.assigns.annotation_type

    changeset =
      %AnnotationForm{}
      |> AnnotationForm.changeset(
        annotation, %{ pages: pages, annotation_types: annotation_types })
      |> Map.put(:action, :insert)

    { :noreply, socket }
  end

  def handle_event("save_annotation", %{"annotation_form" => annotation}, socket) do
    #IO.puts("Handling save annotation event")
    annotation = Helpers.assign_parent_type(annotation)
    %AnnotationForm{}
    |> AnnotationForm.changeset(
      annotation,
      %{ pages: socket.assigns.page, annotation_types: socket.assigns.annotation_type }
    )
    |> Ecto.Changeset.apply_action(:insert)
    |> Helpers.create(:annotation)

    { :noreply, socket }
  end

  def handle_event("annotate_page", data, socket) do
    IO.puts("Creating Job")
    job = %{
      String.to_atom(data["type"]) => String.to_atom(data["id"]),
      job_type: :annotate,
      type:     :job,
      status:   :not_started
    }
    Helpers.create(job, UUID.uuid4(), :job)
    { :noreply, socket}
  end

  def handle_event("hello", _value, socket) do
    { :noreply, assign(socket, new_annotation: true) }
  end

end
