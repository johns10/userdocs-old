defmodule LiveViewWeb.Types.Annotation do
  use Phoenix.LiveView

  def new_map(assigns) do
    %{
      id: nil,

      changeset: nil,
      storage_status: "web",

      name: "",
      label: "",
      description: "",

      annotation_type_id: 1,
      annotation_type: nil
    }
  end

  def changeset(assigns, object) do
    Storage.Annotation.form_changeset(
      %Storage.Annotation{},
      object,
      associations(assigns)
    )
  end

  def associations(assigns) do
    %{annotation_type: assigns.annotation_type}
  end

  def new(socket, _data) do
    LiveViewWeb.Types.Helpers.new(
      socket,
      new_map(socket.assigns),
      changeset(socket.assigns, new_map(socket.assigns))
    )
  end

  def assign_new({socket, object}, id) do
    new_step_changesets =
      socket.assigns.ui["page-menu"]["new-annotations"]
      |> Map.put(id, object)

    assigns =
      Map.get(socket, :assigns)
      |> Kernel.put_in([:ui, "page-menu", "new-annotations"], new_step_changesets)

    assign(socket, assigns)
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

  def expand(socket, id) do
    Helpers.expand(socket, id, :active_annotations)
  end

end
