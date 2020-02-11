defmodule Userdocs.Project.Constants do
  require Logger

  alias Userdocs.Helpers

  ############################## Constants ##########################

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

  def changeset({ assigns, object }) do
    { assigns, changeset(assigns, object) }
  end
  def changeset(assigns, project) do
    Storage.Project.form_changeset(
      %Storage.Project{},
      project,
      associations(assigns)
    )
  end
end
