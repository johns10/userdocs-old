defmodule LiveViewWeb.Project do
  use Phoenix.LiveView

  alias LiveViewWeb.Helpers
  alias LiveViewWeb.Changeset

  require Logger

  ############################## Constants ##########################


  def new_map({ socket, data }) do
    { socket, new_map(socket.assigns) }
  end
  def new_map(assigns) do
    IO.puts("New Project Map")
    team = Enum.at(assigns.team, 0)

    %{
      id: Helpers.provisional_id(),
      changeset: nil,
      storage_status: "web",
      record_status: "new",
      name: "",
      base_url: "",
      project_type: "",
      team_id: team.id,
      team: nil
    }
  end

  def associations(assigns) do
    %{team: assigns.team}
  end

  def current_id(assigns) do
    Map.get(current(assigns), :id)
  end

  def current(assigns) do
    #Logger.debug("It gets the current project from the state")
    id = assigns.current_project_id
    {assigns, result} = StateHandlers.get(assigns, :project, [ id ])
    result
    |> Enum.at(0)
  end

  def changeset({ socket = %Phoenix.LiveView.Socket{}, object }) do
    { socket, changeset(socket.assigns, object) }
  end
  def changeset(assigns, project) do
    Storage.Project.form_changeset(
      %Storage.Project{},
      project,
      associations(assigns)
    )
  end

  ############################# UI ###############################

  def set_default_project(socket) do
    Logger.debug("Setting Default Project")
    Logger.debug(inspect(Enum.at(socket.assigns.project, 0)))
    project = Enum.at(socket.assigns.project, 0)
    id = Helpers.get_id(project.id)
    Logger.debug(id)
    socket = set_current_project(socket, id)
  end

  def set_current_project(socket, id) do
    Logger.debug("Setting Current Project")
    id = Helpers.get_id(id)
    {assigns, objects} = StateHandlers.get(socket.assigns, :project, [id])
    object = Enum.at(objects, 0)
    set_current_project_id(socket, object.id)
  end

  def set_current_project_id({ socket, id }) do
    set_current_project_id(socket, id)
  end
  def set_current_project_id(socket, id) do
    Helpers.put_in_socket(socket, [ :current_project_id ], id)
  end

  def set_default_project_version(socket) do
    Logger.debug("Setting id-less Default Project Version")
    Logger.debug(inspect(socket.assigns.current_project_id))
    id = Helpers.get_id(socket.assigns.current_project_id)
    Logger.debug(id)
    set_default_project_version(socket, id)
  end
  def set_default_project_version(socket, id) do
    Logger.debug("Setting Default Project Version")
    project_id = Helpers.get_id(id)
    {assigns, projects} = StateHandlers.get(
      socket.assigns, :project, [project_id])

    {assigns, versions} = StateHandlers.get_related(
      socket.assigns, :project_id, projects, :version)

    default_version = Enum.at(versions, 0)
    set_default_project_version_id(socket, default_version)
  end

  def set_default_project_version_id(socket, nil) do
    Helpers.put_in_socket(socket, [ :current_version_id ], nil)
  end
  def set_default_project_version_id(socket, version) do
    Helpers.put_in_socket(socket, [ :current_version_id ], version.id)
  end
end
