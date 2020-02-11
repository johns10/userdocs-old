defmodule LiveViewWeb.PagesView do
  # use LiveViewWeb, :view
  use Phoenix.LiveView

  alias LiveViewWeb.Types
  alias LiveViewWeb.Helpers
  alias Storage.AnnotationForm

  alias LiveViewWeb.Project
  alias LiveViewWeb.Version
  alias LiveViewWeb.Data
  alias LiveViewWeb.Changeset

  require Logger

  def render(assigns) do
    ~L"""
    <!DOCTYPE html>

    <html lang="en-US">
      <head>
        <meta charset="utf-8">
        <title>Demo</title>
      </head>
      <div class="container-fluid">
        <div class="row">
          <div class="col-4">
            Project Steps Menu Toggled: <%= @ui["project-steps-menu"]["toggled"] %></br>
            Project Form Toggled: <%= @ui.project_form.toggled %></br>
            Project Form Mode: <%= @ui.project_form.mode %></br>
            Version Form Toggled: <%= @ui.version_form.toggled %></br>
            Page Menu Status: <%= @ui["page-menu"]["active"] %></br>
          </div>
          <div class="col-4">
            Version Form Mode: <%= @ui.version_form.mode %></br>
            Current Project: <%= @current_project_id %></br>
            Project Status: <%= Map.get(Project.current(assigns), :storage_status) %></br>
            Current Version: <%= @current_version_id %></br>
            Project Dropdown Toggled: <%= @ui.project_menu.toggled %></br>
          </div>
          <div class="col-4">
            Version Dropdown Toggled: <%= @ui.version_menu.toggled %></br>
            Active Project Steps: <%= for object <- @ui["project-steps-menu"]["active"] do %>
            <%= object %>
            <% end %></br>
            Active Page Steps: <%= for object <- @ui["page-menu"]["active-steps"] do %>
            <%= object %>
            <% end %></br>
            Active Steps: <%= for object <- assigns.active_steps do %>
            <%= object %>
            <% end %></br>
            Active Annotations: <%= for object <- @ui["page-menu"]["active-annotations"] do %>
            <%= object %>
            <% end %></br>
          </div>
        </div>
      </div>
      <div class="container-fluid">
        <div class="row">
          <div class="col-1">
            <a class="navbar-brand" href="#">UD</a>
          </div>
          <div class="col-4">
          </div>
          <div class="col-4">
            <%= LiveViewWeb.Project.Menu.render(assigns) %>
          </div>
          <%= if @ui.project_form.toggled do %>
            <%= if @ui.project_form.mode == :edit do %>
              <%= LiveViewWeb.Project.Form.render(assigns,
                @changesets.project[assigns.current_project_id]) %>
            <%= else %>
              <%= LiveViewWeb.Project.Form.render(assigns,
                @changesets.project[@current_changesets.new_project]) %>
            <%= end %>
          <%= end %>
          <div class="col-2">
            <%=  Version.Menu.render(assigns) %>
            <%= if @ui.version_form.toggled do %>
              <%= if @ui.version_form.mode == :edit do %>
                <%=
                  Version.Form.render(
                    assigns,
                    @changesets.version[assigns.current_version_id],
                    Project.current(assigns)) %>
              <%= else %>
                <%=
                  Version.Form.render(
                    assigns,
                    Version.Views.new_changeset(assigns),
                    Project.current(assigns)) %>
              <%= end %>
            <%= end %>
          </div>
          <div class="col-1">
            <p>U</p>
          </div>
        </div>
      </div>
      <div class="container-fluid">
        <div
          class="card"
          phx-click="step::toggle_version_step_menu"
        >
          <div class="card-body">
            <h2 class="card-title">
              Project Steps
            </h2>
          </div>
        </div>
        <%= if assigns.ui["project-steps-menu"]["toggled"] == true do %>
          <div class="collapse show">
        <%= else %>
          <div class="collapse">
        <% end %>
          <ul class="list-group">
            <%= if Version.current(assigns) == nil do %>
            <%= else %>
              <%= for step <- Helpers.children(assigns,
                :version_id, Version.current(assigns), :step, :asc) do %>
                <%= if (step.storage_status == "web") do %>
                <%= else %>
                  <%= if step.id in assigns.active_steps do %>
                    <%= LiveViewWeb.StepView.render(
                      @changesets.step[step.id],
                      step,
                      assigns,
                      :header_form,
                      "step::expand") %>
                  <%= else %>
                    <%= LiveViewWeb.StepView.render(
                      step, assigns, :header_only, "step::expand") %>
                  <%= end %>
                <% end %>
              <% end %>
            <% end %>
            <%= if @ui.project_step_form.toggled == false do %>
              <%=
                LiveViewWeb.StepView.render(
                assigns.current_version_id,
                assigns,
                :new_step_button) %>
            <% else %>
              <%=
                version_id = Map.get(Version.current(assigns), :id)
                LiveViewWeb.StepView.render(
                  @changesets.step[@current_changesets.new_version_steps[version_id]],
                  Helpers.get_one(assigns, :step,
                    @current_changesets["new-version-steps"][version_id]),
                  assigns,
                  :empty_header_form)
              %>
            <% end %>
          </ul>
        </div>
      </div>
      <!------------------Pages Menu------------------------->
      <div class="container-fluid">
        <%= if Version.current(assigns) == nil do %>
        <%= else %>
          <%= for page <- Helpers.children(assigns, :version_id, Version.current(assigns), :page) do %>
            <%= if page.id in assigns.active_pages do %>
              <%= LiveViewWeb.PageView.render(assigns, page, :header) %>
              <ul class="list-group">
                <%= for item <- LiveViewWeb.Types.Page.annotations_steps(assigns, page) do %>
                  <%= if item.__struct__ == :"Elixir.Storage.Annotation" do %>
                    <%= if item.id in assigns.active_annotations do %>
                      <%= LiveViewWeb.AnnotationView.render(assigns, item, :header_form) %>
                    <%= else %>
                      <%= LiveViewWeb.AnnotationView.render(assigns, item, :header_only) %>
                    <% end %>
                  <%= else %>
                    <%= if item.id in assigns.active_steps do %>
                      <%= LiveViewWeb.StepView.render(item, assigns, :header_form, "step::expand") %>
                    <%= else %>
                      <%= LiveViewWeb.StepView.render(item, assigns, :header_only, "step::expand") %>
                    <% end %>
                  <% end %>
                <% end %>
            <%= else %>
              <%= LiveViewWeb.PageView.render(assigns, page, :header) %>
            <% end %>
              <li class="list-group-item">
                  <%= case assigns.ui["page-menu"]["form-modes"][page.id] do
                    :new_step ->
                      new_step = assigns.ui["page-menu"]["new-step-changesets"][page.id]
                      LiveViewWeb.StepView.render(new_step, assigns, :header_form, "step::expand")
                    :new_annotation ->
                      new_annotation = assigns.ui["page-menu"]["new-annotations"][page.id]
                      LiveViewWeb.AnnotationView.render(assigns, new_annotation, :header_form)
                    nil ->
                      LiveViewWeb.PageView.render(assigns, page, :footer_menu)
                  end %>
                </div>
              </li>
            </ul>
          <% end %>
        <% end %>
      </div>
    </html>
    """
  end

  def mount(session, socket) do
    :pg2.join(:live_state, self())

    # Application Data Slots
    socket = assign(socket, step_type: [])
    socket = assign(socket, user: [])
    socket = assign(socket, team_user: [])
    socket = assign(socket, team: [])
    socket = assign(socket, project: [])
    socket = assign(socket, version: [])
    socket = assign(socket, page: [])
    socket = assign(socket, step: [])
    socket = assign(socket, annotation: [])
    socket = assign(socket, job: [])
    socket = assign(socket, arg: [])
    # Application Data
    user_id = session.current_user.id
    socket = Helpers.get(socket, :user, [user_id])
    socket = Helpers.get(socket, :annotation_type, [])
    socket = Helpers.get(socket, :step_type, [])
    socket = Helpers.get_all_related_data(socket, :user_id, socket.assigns.user, :team_user)
    socket = Helpers.get(socket, :team, Helpers.forward_ids(socket.assigns.team_user, :team_id))
    socket = Helpers.get_all_related_data(socket, :team_id, socket.assigns.team, :project)
    socket = Helpers.get_all_related_data(socket, :project_id, socket.assigns.project, :version)
    socket = Helpers.get_all_related_data(socket, :version_id, socket.assigns.version, :page)
    socket = Helpers.get_all_related_data(socket, :version_id, socket.assigns.version, :step)
    socket = Helpers.get_all_related_data(socket, :page_id, socket.assigns.page, :step)
    socket = Helpers.get_all_related_data(socket, :page_id, socket.assigns.page, :job)
    socket = Helpers.get_all_related_data(socket, :page_id, socket.assigns.page, :annotation)

    socket =
      Helpers.get_all_related_data(socket, :annotation_id, socket.assigns.annotation, :step)

    # Add subscriptions
    Phoenix.PubSub.subscribe(:live_state, "annotation")
    Phoenix.PubSub.subscribe(:live_state, "job")
    Phoenix.PubSub.subscribe(:live_state, "step")
    Phoenix.PubSub.subscribe(:live_state, "project")
    Phoenix.PubSub.subscribe(:live_state, "version")

    # Gets the default assigns
    socket = assign(socket, Userdocs.Data.new_state())

    socket = Project.set_default_project(socket)
    #Logger.debug("Just set original project default")
    #Logger.debug(inspect(socket.assigns.current_project_id))
    socket = Project.set_default_project_version(socket)

    current_project_id = socket.assigns.current_project_id
    current_project = Helpers.get_one(socket.assigns, :project, current_project_id)
    project_changesets = socket.assigns.changesets.project

    current_project_changeset =
      Project.changeset(socket.assigns, Map.from_struct(current_project))

    project_changesets =
      Map.put(project_changesets, current_project_id, current_project_changeset)

    assigns =
      Map.get(socket, :assigns)
      |> Kernel.put_in([:changesets, :project], project_changesets)

    version = Helpers.get_one(socket.assigns, :version, socket.assigns.current_version_id)
    version_changesets = socket.assigns.changesets.version

    version_changeset =
      if assigns.current_version_id != nil do
        Changeset.new(socket, Map.from_struct(version), "version")
      else
        Changeset.new(socket, Version.new_map(socket.assigns), "version")
      end

    version_changesets =
      Map.put(version_changesets, assigns.current_version_id, version_changeset)

    assigns =
      Map.get(socket, :assigns)
      |> Kernel.put_in([:changesets, :version], version_changesets)

    socket = assign(socket, assigns)

    {:ok, socket}
  end


  def handle_info({ type, command, object }, socket) do
    Logger.debug("Routing to Userdocs Subscription Handler")
    assigns = Userdocs.Subscription.handle_info(
      { type, command, object }, socket.assigns)

    {:noreply, assign(socket, assigns)}
  end

  def handle_info({type = :step, :create = command, object}, socket) do
    IO.puts("Setting current step based on subscription")

    socket =
      assign(
        socket,
        Subscription.Handler.handle(type, command, object, socket.assigns)
      )

    socket = Types.Step.set_current(socket, object.id)
    {:noreply, socket}
  end

  def handle_event("save_annotation", %{"annotation_form" => annotation}, socket) do
    # IO.puts("Handling save annotation event")
    { parent_type , annotation } = Map.pop(annotation, "parent_type")
    { parent_id, annotation } = Map.pop(annotation, "parent_id")
    Map.put(annotation, parent_type, parent_id)

    %Storage.Annotation{}
    |> AnnotationForm.changeset(
      annotation,
      %{pages: socket.assigns.page, annotation_types: socket.assigns.annotation_type}
    )
    |> Ecto.Changeset.apply_action(:insert)
    |> Helpers.create(:annotation)

    {:noreply, socket}
  end

  def handle_event("annotate_page", data, socket) do
    # IO.puts("Creating Job")
    job = %{
      String.to_atom(data["type"]) => String.to_atom(data["id"]),
      job_type: :annotate,
      type: :job,
      status: :not_started
    }

    Helpers.create(job, UUID.uuid4(), :job)
    {:noreply, socket}
  end

  ######################### Annotation Wrappers ######################

  def handle_event("page_annotation_new", data, socket) do
    IO.puts("New Annotation Event")
    id = Helpers.form_id(data)

    socket =
      Types.Annotation.new(socket, id)
      |> Types.Annotation.assign_new(id)
      |> Types.Page.toggle_new_form_mode(id, :new_annotation)

    {:noreply, socket}
  end

  def handle_event("page_annotation_expand", data, socket) do
    IO.puts("Expand Annotation")
    id = Helpers.get_id(data["id"])
    socket = LiveViewWeb.Types.Annotation.expand(socket, id)
    {:noreply, socket}
  end

  def handle_event("annotation::validate", data, socket) do
    Logger.debug("To Validate an Annotation")
    Logger.debug("It extracts the steps from the form, and attaches their respective args")
    form = Map.get(data, "nil")

    submitted_steps =
      Enum.filter(
        form,
        fn {key, value} -> String.starts_with?(key, "step") end
      )
      |> Enum.map(fn {id, object} -> {String.replace(id, "step-", ""), object} end)
      |> Enum.map(fn {key, value} ->
        Map.put(value, "args", Helpers.parse_args(form, key))
      end)

    Logger.debug(inspect(submitted_steps))

    id = Helpers.get_id(form["id"])
    type_id = Helpers.get_id(form["annotation_type_id"])
    type = Helpers.get_one(socket.assigns, :annotation_type, type_id)
    object = Helpers.get_one(socket.assigns, :annotation, id)

    Logger.debug("It creates a new changeset from the form with these changes")
    original_changeset = Types.Annotation.changeset(socket.assigns, Map.from_struct(object))
    updated_changeset = Types.Annotation.changeset(socket.assigns, form)
    Logger.debug(inspect(updated_changeset.changes))

    Logger.debug("It Gets the old changeset or the new one (if nil)")
    old_changeset = socket.assigns.changesets["annotation"][id]

    old_changeset =
      Types.Helpers.check_changeset(old_changeset, updated_changeset, original_changeset)

    Logger.debug(inspect(old_changeset.changes))

    Logger.debug(
      old_changeset.changes.annotation_type_id == updated_changeset.changes.annotation_type_id
    )

    """
    changeset =
      %Storage.Annotation{}
      |> Storage.Annotation.form_changeset(annotation, %{
        pages: pages,
        annotation_types: annotation_types
      })
      |> Map.put(:action, :insert)
    """

    {:noreply, socket}
  end

  ######################### Page Wrappers ############################

  def handle_event("page_expand", data, socket) do
    Logger.debug("Expanding page")
    id = Helpers.get_id(data["id"])
    socket = LiveViewWeb.Types.Page.expand_page(socket, id)
    {:noreply, socket}
  end

  def handle_event(event_name, data, socket) do
    Logger.debug("Routing an event: #{event_name}")
    module_name = String.split(event_name, "::")
    |> Enum.at(0)
    |> Macro.camelize()

    module = String.to_atom("Elixir.LiveViewWeb." <> module_name <> ".Event")

    Kernel.apply(module, :handle_event, [event_name, data, socket])
  end
end
