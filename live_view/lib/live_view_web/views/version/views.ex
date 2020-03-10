defmodule LiveViewWeb.Version.Views do

  require Logger

  def new_changeset(assigns) do
    new_changeset_id =
      assigns.current_changesets.new_project_versions[assigns.current_project_id]
    new_changeset = assigns.changesets.version[new_changeset_id]
    new_changeset
  end

end
