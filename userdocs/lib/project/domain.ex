defmodule Userdocs.Project.Domain do

  require Logger

  alias Userdocs.Helpers

  def set_current_project(assigns, id) do
    Logger.debug("Setting Current Project")
    {assigns, objects} = StateHandlers.get(assigns, :project, [id])
    object = Enum.at(objects, 0)
    set_current_project_id(assigns, object.id)
  end

  def set_current_project_id({ assigns, id }) do
    set_current_project_id(assigns, id)
  end
  def set_current_project_id(assigns, id) do
    Kernel.put_in(assigns, [ :current_project_id ], id)
  end

  def set_default_project_version(assigns) do
    Logger.debug("Setting id-less Default Project Version")
    Logger.debug(inspect(assigns.current_project_id))
    id = Helpers.get_id(assigns.current_project_id)
    Logger.debug(id)
    set_default_project_version(assigns, id)
  end
  def set_default_project_version(assigns, project_id) do
    Logger.debug("Setting Default Project Version")
    {assigns, projects} = StateHandlers.get(
      assigns, :project, [project_id])

    {assigns, versions} = StateHandlers.get_related(
      assigns, :project_id, projects, :version)

    default_version = Enum.at(versions, 0)
    set_default_project_version_id(assigns, default_version)
  end

  def set_default_project_version_id(assigns, nil) do
    Kernel.put_in(assigns, [ :current_version_id ], nil)
  end
  def set_default_project_version_id(assigns, version) do
    Kernel.put_in(assigns, [ :current_version_id ], version.id)
  end

end

