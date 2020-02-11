defmodule Userdocs.Version.Constants do
  require Logger

  alias Userdocs.Helpers

  def new_map(assigns) do
    project_id = assigns.current_project_id

    %{
      id: Helpers.provisional_id(),
      storage_status: "web",
      record_status: "new",
      name: "",
      project_id: project_id,
      project: nil
    }
  end

  def associations(assigns) do
    %{project: assigns.project}
  end

  def current_id(assigns) do
    Map.get(current(assigns), :id)
  end

  def current(assigns) do
    id = assigns.current_version_id
    {assigns, result} = StateHandlers.get(assigns, :version, [id])
    result
    |> Enum.at(0)
  end

  def changeset({ assigns, object }) do
    { assigns, changeset(assigns, object) }
  end
  def changeset(assigns, version) do
    Storage.Version.form_changeset(
      %Storage.Version{},
      version,
      associations(assigns)
    )
  end

end
