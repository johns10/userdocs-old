defmodule LiveViewWeb.Version.Views do

  require Logger

  def new_changeset(assigns) do
    Logger.debug("-----------------Running cc view------------------")
    new_changeset_id =
      assigns.current_changesets.new_project_versions[assigns.current_project_id]
    Logger.debug(new_changeset_id)
    new_changeset = assigns.changesets.version[new_changeset_id]
    Logger.debug(inspect(new_changeset))
    new_changeset
  end

end
