defmodule LiveViewWeb.Page do
  use Phoenix.LiveView
  require Logger

  alias LiveViewWeb.Helpers

  def new_map(assigns) do
    version_id = assigns.current_version_id

    %{
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

  def changeset({ socket = %Phoenix.LiveView.Socket{}, object }) do
    { socket, changeset(socket.assigns, object) }
  end
  def changeset(assigns, version) do
    Storage.Version.form_changeset(
      %Storage.Version{},
      version,
      associations(assigns)
    )
  end

  ############################# CRUD ###############################

end
