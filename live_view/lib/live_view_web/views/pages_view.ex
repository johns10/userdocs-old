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
        <!--<link rel="stylesheet" href="node_modules/uikit/dist/css/uikit.min.css">
        <script src="https://cdn.jsdelivr.net/npm/uikit@3.2.3/dist/js/uikit.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/uikit@3.2.3/dist/js/uikit-icons.min.js"></script>-->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/uikit@3.2.3/dist/css/uikit.min.css" />
      </head>
      <body>
        <%= for { id, project } <- @project do %>
          <%= project.title %>
          <%= for step <- Helpers.children(:project, id, :step, @step) do %>
            <%= LiveViewWeb.StepView.render(step, assigns) %>
          <% end %>
          <%= for { id, page } <- Helpers.children(:project, id, :page, @page) do %>
            <%= if page.active == false do %>
              <div>
                <a
                  href="#"
                  phx-click="active_element"
                  phx-value-id="<%= id %>"
                  phx-value-type="<%= page.type %>"
                  >
                  <h3>
                    <%= page.url %>
                  </h3>
                </a>
              </div>
            <% else %>
              <div>
                <a
                  href="#"
                  phx-click="active_element"
                  phx-value-id="<%= id %>"
                  phx-value-type="<%= page.type %>"
                  >
                  <h3>
                    <%= page.url %>
                  </h3>
                </a>
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
              </div>
            <% end %>
          <% end %>
        <% end %>
      </body>
    </html>
    """
  end

  def mount(_session, socket) do
    :pg2.join(:live_state, self())

    # UI Data
    socket = assign(socket, new_annotation: false)

    # Application Data
    socket = assign(socket, project: %{})
    socket = assign(socket, page: %{})
    socket = assign(socket, step: %{})
    socket = assign(socket, annotation: %{})
    socket = Helpers.get(socket, :project, [:funnel_cloud])
    socket = Helpers.get_all_related_data(socket, :project, Map.keys(socket.assigns.project), :page)
    socket = Helpers.get_all_related_data(socket, :project, Map.keys(socket.assigns.project), :step)
    #socket = Helpers.get(socket, :page, [])
    socket = Helpers.get(socket, :annotation_type, [])
    socket = Helpers.get_all_related_data(socket, :page, Map.keys(socket.assigns.page), :step)
    socket = Helpers.get_all_related_data(socket, :page, Map.keys(socket.assigns.page), :annotation)

    # Add properties for UI controls
    socket = Helpers.add_property(socket, :page, :active, false)
    socket = Helpers.add_property(socket, :annotation, :active, false)
    socket = Helpers.add_property(socket, :step, :active, false)

    # Add injections for future updates
    socket = assign(socket, :injections, %{})

    socket = Helpers.configure_injection(socket, :page)
    socket = Helpers.configure_injection(socket, :annotation)
    socket = Helpers.configure_injection(socket, :step)

    socket = Helpers.add_injection(socket, :page, :active, false)
    socket = Helpers.add_injection(socket, :annotation, :active, false)
    socket = Helpers.add_injection(socket, :step, :active, false)

    # Add subscriptions
    Phoenix.PubSub.subscribe(:live_state, "annotation")

    # Add changesets
    socket = assign(
      socket,
      :annotation_form_changeset,
      AnnotationForm.changeset(
        %AnnotationForm{},
        %{},
        %{ pages: socket.assigns.page, annotation_types: socket.assigns.annotation_type }
      )
    )
    { :ok, socket }
  end

  def handle_info({ data }, socket) do
    Helpers.handle_subscription({ data, socket })
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

  def handle_event("hello", _value, socket) do
    { :noreply, assign(socket, new_annotation: true) }
  end

end
