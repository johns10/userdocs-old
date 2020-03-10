defmodule LiveViewWeb.PagesView do
  # use LiveViewWeb, :view
  use Phoenix.LiveView
  use Phoenix.HTML

  alias LiveViewWeb.Types
  alias LiveViewWeb.Helpers
  alias Storage.AnnotationForm

  alias LiveViewWeb.Project
  alias LiveViewWeb.Content
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
      <%= LiveViewWeb.Debug.MenuStatus.render(assigns) %>
      <%=
        [
          _menu = content_tag(:div, [class: "container-fluid"]) do
            content_tag(:div, [class: "row"]) do
              [
                _home = content_tag(:div, [class: "col-1"]) do
                  content_tag(:a, [class: "navbar-brand", href: "#"]) do
                    "UD"
                  end
                end,
                _content_toggle = content_tag(:div, [class: "col-4"]) do
                  Content.Menu.Toggle.render(assigns)
                end,
                _content_menu = content_tag(:div, []) do
                  if assigns.ui.content_menu.toggled do
                    Content.Menu.render(assigns)
                  else
                    ""
                  end
                end,
                _project_menu = content_tag(:div, [class: "col-4"]) do
                  Project.Menu.render(assigns)
                end,
                _project_form = content_tag(:div, []) do
                  if assigns.ui.project_form.toggled do
                    [
                      if assigns.ui.project_form.mode == :edit do
                        Project.Form.render(assigns,
                          assigns.changesets.project[assigns.current_project_id])
                      else
                        Project.Form.render(assigns,
                          assigns.changesets.project[assigns.current_changesets.new_project])
                      end
                    ]
                  end
                end,
                _version_menu = content_tag(:div, []) do
                  Version.Menu.render(assigns)
                end,
                _version_form = content_tag(:div, []) do
                  if assigns.ui.version_form.toggled do
                    if assigns.ui.version_form.mode == :edit do
                      Version.Form.render(
                        assigns,
                        assigns.changesets.version[assigns.current_version_id],
                        Userdocs.Project.Constants.current(assigns)
                      )
                    else
                      Version.Form.render(
                        assigns,
                        Version.Views.new_changeset(assigns),
                        Userdocs.Project.Constants.current(assigns)
                      )
                    end
                  end
                end,
                _user_icon = content_tag(:div, [ class: "col-1"]) do
                  "U"
                end
                || ""
              ]
            end
          end,
          LiveViewWeb.Version.Body.render(assigns)
          || ""
        ]
      %>

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
    socket = assign(socket, element: [])
    socket = assign(socket, content: [])
    # Application Data
    user_id = session.current_user.id
    socket = Helpers.get(socket, :user, [user_id])
    socket = Helpers.get(socket, :annotation_type, [])
    socket = Helpers.get(socket, :step_type, [])
    socket = Helpers.get_all_related_data(socket, :user_id, socket.assigns.user, :team_user)
    socket = Helpers.get(socket, :team, Helpers.forward_ids(socket.assigns.team_user, :team_id))
    socket = Helpers.get_all_related_data(socket, :team_id, socket.assigns.team, :content)
    socket = Helpers.get_all_related_data(socket, :team_id, socket.assigns.team, :project)
    socket = Helpers.get_all_related_data(socket, :project_id, socket.assigns.project, :version)
    socket = Helpers.get_all_related_data(socket, :version_id, socket.assigns.version, :page)
    socket = Helpers.get_all_related_data(socket, :version_id, socket.assigns.version, :step)
    socket = Helpers.get_all_related_data(socket, :page_id, socket.assigns.page, :step)
    socket = Helpers.get_all_related_data(socket, :page_id, socket.assigns.page, :job)
    socket = Helpers.get_all_related_data(socket, :page_id, socket.assigns.page, :annotation)
    socket = Helpers.get_all_related_data(socket, :page_id, socket.assigns.page, :element)
    socket = Helpers.get_all_related_data(socket, :annotation_id, socket.assigns.annotation, :step)

    # Add subscriptions
    Phoenix.PubSub.subscribe(:live_state, "annotation")
    Phoenix.PubSub.subscribe(:live_state, "job")
    Phoenix.PubSub.subscribe(:live_state, "step")
    Phoenix.PubSub.subscribe(:live_state, "project")
    Phoenix.PubSub.subscribe(:live_state, "version")
    Phoenix.PubSub.subscribe(:live_state, "page")
    Phoenix.PubSub.subscribe(:live_state, "element")
    Phoenix.PubSub.subscribe(:live_state, "content")

    # Gets the default assigns
    socket = assign(socket, Userdocs.Data.new_state())

    team = Enum.at(socket.assigns.team, 0)
    assigns = Map.get(socket, :assigns)
    assigns = Map.put(assigns, :current_team_id, team.id)
    socket = assign(socket, assigns)

    assigns = Userdocs.Project.Domain.set_default_project(socket.assigns)
    assigns = Userdocs.Project.Domain.set_default_project_version(assigns)
    socket = assign(socket, assigns)

    {:ok, socket}
  end


  def handle_info({ type, command, object }, socket) do
    Logger.debug("Routing to Userdocs Subscription Handler")
    assigns = Userdocs.Subscription.handle_info(
      { type, command, object }, socket.assigns)

    {:noreply, assign(socket, assigns)}
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
