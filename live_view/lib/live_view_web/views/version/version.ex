defmodule LiveViewWeb.Version do
  use Phoenix.LiveView
  require Logger

  alias LiveViewWeb.Helpers

  def new_map(assigns) do
    project_id = assigns.current_project_id

    %{
      name: "",
      project_id: project_id,
      id: Helpers.provisional_id(),
      storage_status: "web",
      record_status: "new",
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

  def set_current(socket, id) do
    IO.puts("Setting Current Version")
    id = Helpers.get_id(id)
    {assigns, objects} = StateHandlers.get(socket.assigns, :version, [id])
    object = Enum.at(objects, 0)

    assigns =
      Kernel.put_in(assigns, [ :current_version_id ], object.id)

    assign(socket, assigns)
  end

  def set_mode(socket, mode) do
    assigns =
      Map.get(socket, :assigns)
      |> Kernel.put_in([:ui, "version-form", "mode"], mode)

    assign(socket, assigns)
  end
end
